# CRUD Clientes - Flutter + Dart Server + MariaDB

Sistema completo de CRUD (Create, Read, Update, Delete) para gerenciamento de clientes, desenvolvido com Flutter para frontend, servidor Dart para backend e MariaDB como banco de dados.

## 🚀 Tecnologias Utilizadas

- **Frontend**: Flutter (Web)
- **Backend**: Dart Server com Shelf Framework
- **Banco de Dados**: MariaDB/MySQL
- **HTTP Client**: package:http
- **Arquitetura**: REST API

## 📋 Funcionalidades

- ✅ Listar clientes
- ✅ Adicionar novo cliente
- ✅ Editar cliente existente
- ✅ Excluir cliente
- ✅ Interface responsiva
- ✅ Validação de formulários
- ✅ Tratamento de erros

## 🛠️ Pré-requisitos

- Flutter SDK (^3.8.1)
- Dart SDK
- MariaDB/MySQL Server
- DBeaver (opcional, para gerenciar banco)

## 📦 Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  cupertino_icons: ^1.0.8
  shelf: ^1.4.1
  shelf_router: ^1.1.4
  shelf_cors_headers: ^0.1.5
  mysql1: ^0.20.0
```

## 🗄️ Configuração do Banco de Dados

### 1. Criar o banco e tabela:

```sql
-- Criar banco
CREATE DATABASE IF NOT EXISTS crud_flutter;
USE crud_flutter;

-- Criar tabela
CREATE TABLE clientes (
    codigo INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(150) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    PRIMARY KEY (codigo)
);
```

### 2. Configurar conexão no servidor:

```dart
final settings = ConnectionSettings(
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: '123456',
  db: 'crud_flutter',
);
```

## 🚀 Como Executar

### 1. Clonar o repositório:
```bash
git clone <url-do-repositorio>
cd crud_clientes
```

### 2. Instalar dependências:
```bash
flutter pub get
```

### 3. Configurar banco de dados:
- Execute os comandos SQL acima no MariaDB/MySQL

### 4. Iniciar o servidor backend:
```bash
dart run bin/server.dart
```
Servidor rodará em: `http://localhost:8000`

### 5. Executar o Flutter:
```bash
flutter run -d chrome
```

## 📡 API Endpoints

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/read` | Listar todos os clientes |
| POST | `/api/create` | Criar novo cliente |
| POST | `/api/update` | Atualizar cliente existente |
| POST | `/api/delete` | Excluir cliente |

### Exemplos de Requisições:

#### Criar Cliente:
```json
POST /api/create
{
  "nome": "João Silva",
  "endereco": "Rua das Flores, 123",
  "telefone": "31999999999"
}
```

#### Atualizar Cliente:
```json
POST /api/update
{
  "codigo": 1,
  "nome": "João Santos",
  "endereco": "Rua Nova, 456",
  "telefone": "31888888888"
}
```

#### Excluir Cliente:
```json
POST /api/delete
{
  "codigo": 1
}
```

## 📁 Estrutura do Projeto

```
crud_clientes/
├── bin/
│   └── server.dart          # Servidor Dart backend
├── lib/
│   ├── main.dart           # App Flutter principal
│   ├── models/
│   │   └── cliente.dart    # Modelo Cliente
│   └── services/
│       └── cliente_service.dart # Serviços HTTP
├── pubspec.yaml            # Dependências
└── README.md              # Documentação
```

## 🔧 Configurações Importantes

### CORS Headers
O servidor está configurado para aceitar requisições de qualquer origem:
```dart
.addMiddleware(corsHeaders())
```

### Validações
- Todos os campos são obrigatórios
- Validação no frontend e backend
- Tratamento de erros HTTP

## 🐛 Solução de Problemas

### Erro: "Field 'codigo' doesn't have a default value"
**Solução**: Verificar se o campo `codigo` tem AUTO_INCREMENT:
```sql
DESCRIBE clientes;
-- Campo codigo deve ter "auto_increment" na coluna Extra
```

### Erro de Conexão com Banco
**Solução**: Verificar:
- MariaDB/MySQL está rodando
- Credenciais corretas no `server.dart`
- Nome do banco existe

### CORS Error
**Solução**: Servidor já configurado com CORS headers

## 👥 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT.

## 📞 Contato

- Desenvolvedor: [Seu Nome]
- Email: [seu-email@exemplo.com]
- GitHub: [seu-usuario]
