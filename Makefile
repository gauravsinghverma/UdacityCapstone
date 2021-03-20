setup:
	sudo apt-get update
	sudo apt-get install python3-venv
	python3 -m venv devops
	. devops/bin/activate

install:
# This should be run from inside a virtualenv
	pip install --upgrade pip &&\
		pip install -r requirements.txt &&\
        sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64 &&\
		sudo chmod +x /bin/hadolint
lint:
	hadolint Dockerfile --ignore DL4000
	pylint --disable=R,C,W1203 app.py

all: install lint test
