type -q docker; or exit 0

# ---- General
alias d docker

# ---- Images - di<action>
alias dil 'docker images'
alias dibu 'docker build'
alias dix 'docker rmi'
alias dih 'docker history'

function diX
    docker rmi $argv (docker images -a -q)
end

function dixd
    docker rmi $argv (docker images -q -f "dangling=true")
end

# ---- Containers - dc<action>
alias dcl 'docker ps'

function dci
    docker inspect --format "{{ .NetworkSettings.IPAddress }}" $argv
end

alias dcr 'docker run -it'
alias dcex 'docker exec -it'
alias dclg 'docker logs'

function dcs
    docker stop $argv
end

function dcS
    docker stop $argv (docker ps -q -f "status=running")
end

alias dcx 'docker rm'

function dcxs
    docker rm $argv (docker ps -q -f "status=exited")
end

function dcX
    docker rm $argv (docker ps -a -q)
end

# ---- Volumes - dv<action>
function dvl
    docker volume ls $argv
end

function dvX
    docker volume rm (docker volume ls -q)
end

function dvxd
    docker volume rm (docker volume ls -q -f "dangling=true")
end

# ---- Network - dn<action>
alias dnl 'docker network list'
alias dnn 'docker network create'
alias dno 'docker network connect'
alias dnx 'docker network rm'
alias dnX 'docker network prune'

# ---- Compose - dC<action> (new) 
# ---- Prefer: docker compose ...
# ---- Fallback: docker-compose ...
set -g __docker_compose_cmd

if docker compose version >/dev/null 2>&1
    set -g __docker_compose_cmd docker compose
else if type -q docker-compose
    set -g __docker_compose_cmd docker-compose
end

function __dC
    test -n "$__docker_compose_cmd"; or begin
        echo "docker compose not found (neither 'docker compose' nor 'docker-compose')." >&2
        return 127
    end

    command $__docker_compose_cmd $argv
end

# ---- Compose
alias dCl  '__dC ps'
alias dClg '__dC logs'
alias dCr  '__dC run'
alias dCex '__dC exec'
alias dCbu '__dC build'

function dCs
    __dC stop $argv
end

function dCS
    __dC stop $argv (__dC ps -q)
end

function dCx
    __dC rm $argv
end

function dCX
    __dC rm -f -s -v $argv (__dC ps -aq)
end

# Common compose lifecycle helpers (extra, but consistent with the pattern)
alias dCu  '__dC up'
alias dCud '__dC up -d'
alias dCd  '__dC down'
alias dCps '__dC ps'
alias dCcp '__dC cp'
alias dCpl '__dC pull'
alias dCrt '__dC restart'
