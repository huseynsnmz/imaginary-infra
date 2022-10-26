# pyinfra

```
python3 -m pip install --user pipx
python3 -m pipx ensurepath

pipx install pyinfra

pyinfra my-server.net exec -- echo "hello world"
pyinfra @docker/ubuntu apt.packages iftop update=true _sudo=true
```
