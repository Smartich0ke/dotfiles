if status is-interactive

alias python=python3
alias k=kubectl

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

end

export PICO_SDK_PATH=/home/npatrick/Code/pico/pico-sdk
export PICO_EXAMPLES_PATH=/home/npatrick/Code/pico/pico-examples
export PICO_EXTRAS_PATH=/home/npatrick/Code/pico/pico-extras
export PICO_PLAYGROUND_PATH=/home/npatrick/Code/pico/pico-playground

set -gx KUBECONFIG ~/.kube/pleiades.yaml

set -gx NVM_SYMLINK_CURRENT true

if test -f .nvmrc
    nvm install
end

set fish_greeting

starship init fish | source
