import re

from flask import Flask, request, jsonify
from flask_cors import CORS
import requests

app = Flask(__name__)
CORS(app)  # necessário para o front-end conseguir chamar a API

XANO_BUSCA_URL = "https://x8ki-letl-twmt.n7.xano.io/api:1feaaExa/auth/login"

# Troque pela URL do endpoint de cadastro (auth/cadastro) do seu Xano
XANO_CADASTRO_URL = "COLOQUE_AQUI_A_URL_DO_ENDPOINT_AUTH_CADASTRO"

MSG_CREDENCIAIS_INVALIDAS = "Email ou senha incorretos."


@app.route("/login", methods=["POST"])
def login():
    dados = request.get_json(silent=True) or {}

    email = dados.get("email", "").strip().lower()
    senha = dados.get("senha", "")

    # =========================
    # VALIDAÇÕES
    # =========================

    if not email:
        return jsonify({"sucesso": False, "mensagem": "Digite seu email."}), 400

    if not senha:
        return jsonify({"sucesso": False, "mensagem": "Digite sua senha."}), 400

    if "@" not in email or "." not in email.split("@")[-1]:
        return jsonify({"sucesso": False, "mensagem": "Digite um email válido."}), 400

    # =========================
    # 1. BUSCA O COMERCIANTE NO XANO PELO E-MAIL
    # =========================

    try:
        print("URL chamada pelo xano:", XANO_BUSCA_URL)
        resposta = requests.post(
            XANO_BUSCA_URL,
            json={"email": email,
                  "senha": senha},
            timeout=10
        )
    except requests.RequestException:
        return jsonify({"sucesso": False, "mensagem": "Erro de conexão."}), 503

    print("Status do Xano:", resposta.status_code)
    print("Resposta do Xano:", resposta.text)

    # =========================
    # 2. USUÁRIO NÃO ENCONTRADO OU ERRO NO XANO
    # =========================

    if resposta.status_code != 200:
        # Registre o detalhe no terminal do Python,
        # sem devolver informações internas ao navegador.
        app.logger.error(
            "Falha no Xano: status=%s, resposta=%s",
            resposta.status_code,
            resposta.text[:500]
        )

        if resposta.status_code in (400, 401, 403, 404):
            return jsonify({
                "sucesso": False,
                "mensagem": "Não foi possível validar as credenciais."
            }), 401

        return jsonify({
            "sucesso": False,
            "mensagem": "Erro interno ao consultar o serviço de autenticação."
        }), 502

    try:
        comerciante = resposta.json()
    except ValueError:
        return jsonify({"sucesso": False, "mensagem": "Resposta inválida do servidor."}), 502

    if not comerciante or not isinstance(comerciante, dict):
        return jsonify({"sucesso": False, "mensagem": MSG_CREDENCIAIS_INVALIDAS}), 401

    # =========================
    # 3. LOGIN VALIDADO PELO XANO (status 200)
    # =========================

    # "comerciante" aqui é a resposta do Xano (não o corpo da requisição)
    comerciante = comerciante.get("comerciante", {})

    return jsonify({
        "mensagem": "Login realizado com sucesso",
        "funcao": comerciante.get("funcao"),
        "nome": comerciante.get("nome")
    })


@app.route("/cadastro", methods=["POST"])
def cadastro():
    dados = request.get_json(silent=True) or {}

    # str(... or "") evita erro caso o campo venha como null ou não seja texto
    nome = str(dados.get("nome") or "").strip()
    email = str(dados.get("email") or "").strip().lower()
    senha = str(dados.get("senha") or "")

    # 1. Validar campos obrigatórios
    if not nome or not email or not senha:
        return jsonify({
            "sucesso": False,
            "mensagem": "Preencha todos os campos."
        }), 400

    # 2. Exigir um endereço terminado em @gmail.com
    if not re.fullmatch(
        r"[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@gmail\.com",
        email
    ):
        return jsonify({
            "sucesso": False,
            "mensagem": "Use um e-mail terminado em @gmail.com."
        }), 400

    # 3. Exigir pelo menos 6 caracteres na senha
    if len(senha) < 6:
        return jsonify({
            "sucesso": False,
            "mensagem": "A senha deve ter pelo menos 6 caracteres."
        }), 400

    # 4. Enviar o cadastro ao Xano
    try:
        resposta = requests.post(
            XANO_CADASTRO_URL,
            json={
                "nome": nome,
                "email": email,
                "senha": senha
            },
            timeout=15
        )
    except requests.RequestException:
        return jsonify({
            "sucesso": False,
            "mensagem": "Não foi possível conectar ao servidor."
        }), 503

    # 5. Tratar o resultado
    if resposta.status_code not in (200, 201):
        # Detalhe só no terminal do Python, sem expor ao navegador
        app.logger.error(
            "Falha no cadastro Xano: status=%s, resposta=%s",
            resposta.status_code,
            resposta.text[:500]
        )
        return jsonify({
            "sucesso": False,
            "mensagem": "Não foi possível cadastrar. Verifique se o e-mail já existe."
        }), 400

    return jsonify({
        "sucesso": True,
        "mensagem": "Cadastro realizado com sucesso!"
    }), 201


if __name__ == "__main__":
    app.run(debug=True)