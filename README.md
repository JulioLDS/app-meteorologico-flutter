# 🌤️ App Meteorológico - Clima Brasil

Aplicativo moderno de previsão do tempo desenvolvido em **Flutter**, com design **Glassmorphism**, integração em tempo real com a **OpenWeatherMap**, persistência de dados no **Supabase** e gráficos interativos.

##  Funcionalidades
- 🔍 Busca dinâmica de cidades com barra de pesquisa estilizada
- ️ Dados climáticos em tempo real (temperatura, umidade, vento)
- 📊 Gráficos de variação e histórico de temperatura (`fl_chart`)
- 🗄️ Persistência online no Supabase e local (`shared_preferences`)
- 🎨 Interface premium com blur, gradientes dinâmicos e animações climáticas
- 📤 Compartilhamento rápido (WhatsApp, Twitter/X e nativo)
- 📱 Layout responsivo (Desktop com painéis lado a lado / Mobile com scroll unificado)

## 🛠️ Tecnologias
| Área | Tecnologia |
|---|---|
| **Framework** | Flutter & Dart |
| **Estado** | Provider |
| **API Climática** | OpenWeatherMap |
| **Banco de Dados** | Supabase |
| **Gráficos** | fl_chart |
| **Compartilhamento** | share_plus, url_launcher |

## ⚙️ Configuração Prévia
1. **OpenWeatherMap**: Gere uma chave gratuita em [openweathermap.org/api](https://openweathermap.org/api) e insira em `lib/services/weather_service.dart`.
2. **Supabase**: Crie um projeto, configure a tabela `weather_logs` e insira a URL e `anon key` em `lib/services/supabase_service.dart`.

## ▶️ Como Executar
Abra o terminal na pasta raiz do projeto e execute:

```bash
# 1. Acesse a pasta do projeto Flutter
cd app_meteorologico

# 2. Instale as dependências
flutter pub get

# 3. Execute o app no navegador (recomendado para Codespaces/Web)
flutter run -d web-server --web-port=3000 --web-hostname 0.0.0.0
