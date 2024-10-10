#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================
nodejs_version=18

#=================================================
# PERSONAL HELPERS
#=================================================
install_wkhtmltopdf_patched_qt_package() {
    # Create the temporary directory
	tempdir="$(mktemp -d)"
	# Download the deb files
	ynh_setup_source --dest_dir="$tempdir" --source_id="wkhtmltopdf_patched_qt"
    # Install the package
    ynh_package_install \
        "$tempdir/wkhtmltopdf_patched_qt.deb"
    # Mark packages as dependencies, to allow automatic removal
    apt-mark auto wkhtmltopdf
}

uninstall_wkhtmltopdf_patched_qt_package() {
    apt-mark unhold wkhtmltopdf
    ynh_package_autopurge wkhtmltopdf
}

install_app_to_bench() {
    
    local apps_dir=$install_dir/dokos-bench-folder/apps

    ynh_setup_source --dest_dir="$apps_dir/$1" --source_id="$1"

    chmod u+x $install_dir/dokos-bench-folder/env/bin/activate
    ynh_exec_as $app $install_dir/dokos-bench-folder/env/bin/activate
    ynh_exec_as $app $install_dir/dokos-bench-folder/env/bin/python -m pip install --upgrade -e $apps_dir/$1

    chown -R $app: "$apps_dir/$1"

    local apps_list=$install_dir/dokos-bench-folder/sites/apps.txt
    if test -f "$apps_list"; then
        ynh_exec_as $app echo -e "\n$1" >> $apps_list
    else 
        ynh_exec_as $app echo "$1" >> $apps_list
    fi

    pushd $apps_dir/$1
        ynh_use_nodejs
        ynh_exec_as $app env $ynh_node_load_PATH yarn install --check-files

        # Builds assets for the Frappe Applications installed on bench
        ynh_exec_as $app env PATH=$install_dir/bin:$PATH bench build --app $1
    popd

}

upgrade_app_to_bench() {
    
    local apps_dir=$install_dir/dokos-bench-folder/apps

    ynh_setup_source --dest_dir="$apps_dir/$1" --source_id="$1" --full_replace

    chmod u+x $install_dir/dokos-bench-folder/env/bin/activate
    ynh_exec_as $app $install_dir/dokos-bench-folder/env/bin/activate
    ynh_exec_as $app $install_dir/dokos-bench-folder/env/bin/python -m pip install --upgrade -e $apps_dir/$1

    chown $app: -R "$apps_dir/$1"

    pushd $apps_dir/$1
        ynh_use_nodejs
        ynh_exec_as $app env $ynh_node_load_PATH yarn install --check-files
        
        # Builds assets for the Frappe Applications installed on bench
        ynh_exec_as $app env PATH=$install_dir/bin:$PATH bench build --app $1
    popd

}