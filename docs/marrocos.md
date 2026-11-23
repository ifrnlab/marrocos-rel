# Relatório sobre Marrocos

## Detalhes do sistema operacional

```{literalinclude} etc/os-release
```

## Espaço em disco

```{literalinclude} df-h.txt
```

## Discos e partições

```{literalinclude} lsblk-p.txt
```

## Uso de memória RAM

```{literalinclude} free-h.txt
```

## Endereçamento IPv4

```{literalinclude} ip-br-c-4-address.txt
```

## Portas abertas do TCP

```{literalinclude} ss-tnl.txt
```

## Portas abertas do UDP

```{literalinclude} ss-unl.txt
```

## Configurações do servidor DHCP

```{literalinclude} etc/dhcp/dhcpd.conf
```

## Configurações do servidor DHCP para estações

```{literalinclude} etc/dhcp/dhcpd-estacoes.conf
```

## Regras do firewall UFW

```{literalinclude} etc/ufw/before.rules
```

## Perfil padrão do incus

```{literalinclude} incus-default-profile.yaml
```


## Lista de contêineres e VMs do incus

```{csv-table} Lista de contêineres e VMs do incus
:file: incus-list.csv
:header-rows: 1
```

## Lista de volumes do incus

```{csv-table} Lista de volumes do incus
:file: incus-storage-volume-list.csv
:header-rows: 1
```
