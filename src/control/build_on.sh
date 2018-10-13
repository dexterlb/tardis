host="${1}"
target="${2}"
cdir="$(dirname "${0}")"

if [[ -z "${build_dir}" ]]; then
    build_dir="/tmp/control_build"
fi


cd "${cdir}"

mix deps.get || exit
mix build_web || exit

rsync -rvz --exclude _build --delete "${cdir}" "${host}":${build_dir} || exit

ssh "${host}" "sh -c 'cd ${build_dir} && export LANG=en_GB.UTF-8 && MIX_ENV=prod mix release --executable --transient'" || exit

if [[ -n "${target}" ]]; then
    rsync -rvz "${host}:${build_dir}/_build/prod/rel/control/bin/control.run" /tmp/control.run

    rsync -rvz /tmp/control.run "${target}"
fi
