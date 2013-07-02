#!/usr/bin/env bash

source environment.sh

source base.sh

containsElement () {
    local element;
    for element in "${@:2}";
    do
        [[ "${element}" == "$1" ]] && return 0;
    done
    return 1
}


export ENV_RUBY_MAIN_VERSION="1.9.3"
export ENV_RUBY_PATCH_VERSION="-p392"
export ENV_RUBY_VERSION="${ENV_RUBY_MAIN_VERSION}${ENV_RUBY_PATCH_VERSION}"
export ENV_RBENV_HOME="${HOME}/.rbenv"
export ENV_RBENV_PLUGINS_HOME="${ENV_RBENV_HOME}/plugins"
export ENV_RUBY_BUILD_HOME="${ENV_RBENV_PLUGINS_HOME}/ruby-build"

# install rbenv plugins
RBENV_INSTALLPLUGINS=('rbenv-gem-rehash' 'rbenv-default-gems')
# install default gems for rbenv
RBENV_DEFAULTGEMS=('bundler' 'berkshelf' 'foodcritic' 'knife-solo' 'knife-solo_data_bag')

#sudo apt-get -y install build-essential zlib1g-dev libreadline-dev libssl-dev libcurl4-openssl-dev


# check if ruby exists and which version it is
case "$(ruby -v)" in
    *${ENV_RUBY_MAIN_VERSION}* )
        echo "ruby with correct version already exists.";
        exit 1;
    ;;
    * )
        echo "ruby with correct version doesn't exist, installing...";
    ;;
esac

# Default to rbenv install
if [ -z "${ENV_RUBY_INSTALLMETHOD}" ]; then
  export ENV_RUBY_INSTALLMETHOD="rbenv"
fi

echo "Installing ruby using ${ENV_RUBY_INSTALLMETHOD} as install method."


# Installing ruby
case ${ENV_RUBY_INSTALLMETHOD} in
  "source" )
    # Install Ruby from source
    if [ -z "${ENV_RUBY_VERSION}" ]; then
      # Default to latest
      echo "install latest"
    else
      wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-${ENV_RUBY_VERSION}.tar.gz
      tar xvzf ruby-${ENV_RUBY_VERSION}.tar.gz
      cd ruby-${ENV_RUBY_VERSION}
      ./configure --prefix=/opt/ruby
      make
      make install
      cd ..
      rm -rf ruby-${ENV_RUBY_VERSION}
    fi
    ;;
  "rbenv" )
    # Using rbenv (install when necessary)
    if [ -d "${ENV_RBENV_HOME}" ]; then
        echo "${ENV_RBENV_HOME} already exists."
        # pull new version?
    else
        (cd && git clone https://github.com/sstephenson/rbenv.git ${ENV_RBENV_HOME})
        # Add rbenv to your PATH
        # NOTE: rbenv is *NOT* compatible with rvm, so you'll need to remove rvm from your profile if it's present.
        # (This is because rvm overrides the `gem` command.)
        echo 'export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"' >> ${ENV_BASH_SETTINGS}
        echo 'eval "$(rbenv init -)"' >> ${ENV_BASH_SETTINGS}
        source ${ENV_BASH_SETTINGS}
    fi

    if [ -z "${ENV_RUBY_VERSION}" ]; then
        echo "install latest"
    else
        # Install Ruby versions into ~/.rbenv/versions - ruby-build is a convenient way to do this
        if [ -d "${ENV_RBENV_PLUGINS_HOME}/ruby-build" ]; then
            (cd ${ENV_RBENV_PLUGINS_HOME}/ruby-build && git pull)
        else
            cd && git clone https://github.com/sstephenson/ruby-build.git ${ENV_RBENV_PLUGINS_HOME}/ruby-build
        fi

        # install specified ruby version
        if [ -d "${ENV_RBENV_HOME}/versions/${ENV_RUBY_VERSION}" ]; then
            echo "ruby version ${ENV_RUBY_VERSION} already installed."
        else
            rbenv install ${ENV_RUBY_VERSION}
        fi

        # Install shims for all Ruby binaries
        rbenv rehash

        # Set a default Ruby version
        rbenv global ${ENV_RUBY_VERSION}
        rbenv rehash
    fi

    for plugin in "${RBENV_INSTALLPLUGINS[@]}";
    do
        if [ -d "${ENV_RBENV_PLUGINS_HOME}/${plugin}" ]; then
            (cd "${ENV_RBENV_PLUGINS_HOME}/${plugin}" && git pull)
        else
            cd && git clone https://github.com/sstephenson/${plugin}.git ${ENV_RBENV_PLUGINS_HOME}/${plugin}
        fi
    done

    if [ -f "${ENV_RBENV_PLUGINS_HOME}/rbenv-default-gems" ]; then
    if containsElement "rbenv-default-gems" "${RBENV_INSTALLPLUGINS[@]}"; then
        for gem in "${RBENV_DEFAULTGEMS[@]}";
        do
            echo ${gem} >> ${ENV_RBENV_HOME}/default-gems
        done
    fi
    ;;
  "rvm" )
    # Using rvm
    if [ -z "${ENV_RUBY_VERSION}" ]; then
      # Default to latest
      sudo aptitude update && sudo aptitude install curl -y
      \curl -L https://get.rvm.io | bash -s stable --ruby
    else
      wget -O - http://opscode.com/chef/install.sh | sudo bash -s -- -v ${ENV_RUBY_VERSION}
    fi
    ;;

  "package" )
    # Using packages
    if [ -z "${ENV_RUBY_VERSION}" ]; then
      # Default to latest
      sudo apt-get install ruby rubygems ruby-dev -y
    fi
    ;;
  * )
    echo "Unsupported method for installing ruby"
    exit -1
    ;;
esac
