#!/usr/bin/env bash
#set -Eeuo pipefail

# Obtém os nomes das instâncias cadastradas no Incus.
mapfile -t vms < <(incus list -f csv -c n)

# Percorre todas as instâncias.
for vm in "${vms[@]}"; do

    echo "========================================"
    echo "Instância: ${vm}"
    echo "========================================"

    # Cria o diretório para armazenar os relatórios.
    mkdir -p "${vm}"

    # Inicia a instância somente se estiver parada.
    if [[ "$(incus info "${vm}" | grep '^Status:' | awk '{print $2}')" != "RUNNING" ]]; then
        incus start "${vm}"
    fi

    # Salva o nome da máquina
    incus file pull "${vm}/etc/hostname" "${vm}/hostname.txt"

    # Identifica o sistema operacional e instala iproute2,
    # caso o comando ss não esteja disponível.
    incus exec "${vm}" -- sh -c '
        set -e

        if ! command -v ss >/dev/null 2>&1; then

            . /etc/os-release

            echo "Instalando iproute na distribuição: ${PRETTY_NAME}"

            case "${ID} ${ID_LIKE:-}" in

                *alpine*)
                    apk add --no-cache iproute2
                    ;;

                *debian*|*ubuntu*)
                    apt-get update
                    apt-get install -y iproute2
                    ;;

                *almalinux*|*rocky*|*rhel*|*fedora*)
                    dnf install -y iproute
                    ;;

                *)
                    echo "Distribuição não reconhecida: ${ID}"
                    exit 1
                    ;;
            esac
        fi

        # Confirma a disponibilidade do comando.
        command -v ss
    '

    # Aguarda a instância estar operacional.
    incus exec "${vm}" -- true

    # Serviços TCP em escuta.
    incus exec "${vm}" -- ss -tnl \
        > "${vm}/ss-tnl.txt"

    # Serviços UDP em escuta.
    incus exec "${vm}" -- ss -unl \
        > "${vm}/ss-unl.txt"

    # Sistemas de arquivos.
    incus exec "${vm}" -- df -h \
        > "${vm}/df-h.txt"

    # Memória RAM e swap.
    incus exec "${vm}" -- free -h \
        > "${vm}/free-h.txt"

    # Interfaces de rede IPv4.
    incus exec "${vm}" -- ip -br -4 address \
        > "${vm}/ip-br-c-4-address.txt"

    echo "Relatórios concluídos: ${vm}"

done

echo "Coleta finalizada."

