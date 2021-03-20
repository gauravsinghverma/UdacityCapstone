setup:
	python3 -m venv ~/.devops
		#
install:
# This should be run from inside a virtualenv
	pip install --upgrade pip &&\
		pip3 install -r requirements.txt &&\
        wget -O ./hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64 &&\
                chmod +x ./hadolint
lint:
	hadolint Dockerfile --ignore DL4000
	pylint --disable=R,C,W1203 app.py

all: install lint test
