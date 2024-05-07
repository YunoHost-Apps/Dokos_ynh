#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================
nodejs_version=18

#=================================================
# PERSONAL HELPERS
#=================================================
install_app_to_bench() {
    
    local apps_dir=$install_dir/dokos-bench-folder/apps

    ynh_setup_source --dest_dir="$apps_dir/$1" --source_id="$1"

    chmod u+x $install_dir/dokos-bench-folder/env/bin/activate
    ynh_exec_as $app $install_dir/dokos-bench-folder/env/bin/activate
    ynh_exec_as $app $install_dir/dokos-bench-folder/env/bin/python -m pip install --upgrade -e $apps_dir/$1

    chown -R $app:www-data "$apps_dir/$1"

    ynh_exec_as $app echo -e "\n$1" >> $install_dir/dokos-bench-folder/sites/apps.txt

    pushd $apps_dir/$1
        ynh_use_nodejs
        ynh_exec_as $app env $ynh_node_load_PATH yarn install --check-files
        ynh_exec_as $app env PATH=$install_dir/bin:$PATH bench build --app $1
    popd

}