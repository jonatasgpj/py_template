ORIGINAL_NAME="meu_projeto"
REPO_URL="https://github.com/jonatasgpj/py_template"

#python3
check_python() {
    if ! command -v python3 &> /dev/null; then
        echo "Python 3 não está instalado. Instale o Python 3."
        exit 1
    else
        echo "Python 3 já instalado."
    fi
}

#pip
check_pip() {
    if ! command -v pip3 &> /dev/null; then
        echo "pip3 não está instalado. Deseja instalar?"
        sudo apt update
        sudo apt install python3-pip -y
        if ! command -v pip3 &> /dev/null; then
            echo "Não foi possível instalar o pip3. Verifique sua configuração de repositórios."
            exit 1
        fi
    else
        echo "pip3 está instalado."
    fi
}

NEW_NAME=$1

if [ -z "$NEW_NAME" ]; then
    echo "Uso: ./projeto_py.sh nome_do_novo_projeto"
    exit 1
fi

#verifica as instalações
check_python
check_pip

#git clone
echo "Clonando projeto base..."
git clone --depth 1 "$REPO_URL" "$NEW_NAME"

if [ $? -ne 0 ]; then
    echo " Erro ao clonar o repositório."
    exit 1
fi

#Entrando na pasta do novo projeto
cd "$NEW_NAME"

#remove o git
rm -rf .git

#substituindo valores do novo projeto
echo "Renomeando de '$ORIGINAL_NAME' para '$NEW_NAME'..."
grep -rl "$ORIGINAL_NAME" . | xargs sed -i "s/$ORIGINAL_NAME/$NEW_NAME/g"

#verifica os requerimentos
echo " Instalando dependências com pip..."
pip3 install -r requirements.txt

#iniciando projeto Uvicorn
echo " Iniciando servidor com Uvicorn..."
echo "Projeto '$NEW_NAME Verifique em: http://127.0.0.1:8000"
python3 run.py


