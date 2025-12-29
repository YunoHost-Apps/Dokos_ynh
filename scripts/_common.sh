#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

install_wkhtmltopdf_patched_qt_package() {
    # Create the temporary directory
	tempdir="$(mktemp -d)"
	# Download the deb files
	ynh_setup_source --dest_dir="$tempdir" --source_id="wkhtmltopdf_patched_qt"
    # Install the package
    _ynh_apt_install \
        "$tempdir/wkhtmltopdf_patched_qt.deb"
    # Mark packages as dependencies, to allow automatic removal
    apt-mark auto wkhtmltopdf
}

uninstall_wkhtmltopdf_patched_qt_package() {
    apt-mark unhold wkhtmltopdf
    _ynh_apt autoremove --purge wkhtmltopdf
}

install_app_to_bench() {

    local apps_dir=$install_dir/dokos-bench-folder/apps

    if [ $1 == "erpnext" ]; then
        src="main"
    else
        src="$1"
    fi
    ynh_setup_source --dest_dir="$apps_dir/$1" --source_id="$src"

    chmod u+x $install_dir/dokos-bench-folder/env/bin/activate
    ynh_hide_warnings ynh_exec_as_app $install_dir/dokos-bench-folder/env/bin/activate
    ynh_hide_warnings ynh_exec_as_app $install_dir/dokos-bench-folder/env/bin/python -m pip install --upgrade -e $apps_dir/$1

    chown -R $app: "$apps_dir/$1"

    local apps_list=$install_dir/dokos-bench-folder/sites/apps.txt
    if test -f "$apps_list"; then
        ynh_hide_warnings ynh_exec_as_app echo -e "\n$1" >> $apps_list
    else

        ynh_hide_warnings ynh_exec_as_app echo "$1" >> $apps_list
    fi

    pushd $apps_dir/$1

        ynh_hide_warnings ynh_exec_as_app yarn install --check-files

        # Builds assets for the Frappe Applications installed on bench
        ynh_hide_warnings ynh_exec_as_app PATH=$install_dir/bin:$PATH bench build --app $1
    popd

}

upgrade_app_to_bench() {

    local apps_dir=$install_dir/dokos-bench-folder/apps

    if [ $1 == "erpnext" ]; then
        src="main"
    else
        src="$1"
    fi

    ynh_setup_source --dest_dir="$apps_dir/$1" --source_id="$1" --full_replace

    chmod u+x $install_dir/dokos-bench-folder/env/bin/activate
    ynh_hide_warnings ynh_exec_as_app $install_dir/dokos-bench-folder/env/bin/activate
    ynh_hide_warnings ynh_exec_as_app $install_dir/dokos-bench-folder/env/bin/python -m pip install --upgrade -e $apps_dir/$1

    chown $app: -R "$apps_dir/$1"

    pushd $apps_dir/$1

        ynh_hide_warnings ynh_exec_as_app yarn install --check-files

        # Builds assets for the Frappe Applications installed on bench
        ynh_hide_warnings ynh_exec_as_app PATH=$install_dir/bin:$PATH bench build --app $1
    popd

}
