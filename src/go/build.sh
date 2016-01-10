path="$(dirname "$(readlink -f "${0}")")"/.gopath

packages=(tardis/spi_check)

build_dir="${path}/bin/linux_arm"
destination="tardis:/home/human/bin"

export GOPATH="${path}"
export GOOS=linux
export GOARCH=arm
export GO15VENDOREXPERIMENT=1 

function build {
    for package in ${packages[@]}; do
        go install "${package}"
        
        status=$?
        if [[ "${status}" -ne 0 ]]; then
            return "${status}";
        fi
    done
}

function sync {
    rsync --progress -hvr "${build_dir}/" "${destination}"
}

function clean {
    rm -rf "${path}/bin"
    rm -rf "${path}/pkg"
}

if [[ "${1}" == "go" ]]; then
    go "${@:2}"
elif [[ "${1}" == "build" ]]; then
    build
elif [[ "${1}" == "sync" ]]; then
    build && sync
elif [[ "${1}" == "clean" ]]; then
    clean
fi
