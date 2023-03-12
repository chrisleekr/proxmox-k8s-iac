all:
  hosts:
%{ for index, id in workers_names ~}
    ${id}.cluster:
      alias: ${id}
      ansible_host: ${workers_ips[index]}
      ansible_user: ${workers_user}
%{ endfor ~}
  children:
    primary_nodes:
      hosts:
        ${workers_names[0]}.cluster:
    secondary_nodes:
      hosts:
%{ for id in slice(workers_names, 1, length(workers_names)) ~}
        ${id}.cluster:
%{ endfor ~}