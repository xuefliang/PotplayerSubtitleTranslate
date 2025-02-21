# Potplayer Subtitle Translation Plugin | Potplayer字幕翻译插件

[English](#english) | [中文](#chinese)

<a name="english"></a>
## English

### Introduction
A real-time subtitle translation plugin for Potplayer that utilizes LLM (Large Language Models) to translate subtitles during playback.

### Features
- Real-time subtitle translation
- Support for multiple LLM models
- Seamless integration with Potplayer

### Installation
1. Copy the plugin files to `Potplayer\Extension\Subtitle\Translate`
2. Modify the following configuration in `llm.as`:
   - `api_key`: Your API key
   - `selected_model`: Your chosen LLM model
   - `api_url`: API endpoint URL

### Configuration
```javascript
// Example configuration in llm.as
api_key = "your_api_key_here"
selected_model = "model_name"
api_url = "https://api.example.com"
```

### Requirements
- Potplayer installed
- Valid API key for the chosen LLM service

---

<a name="chinese"></a>
## 中文

### 简介
这是一个Potplayer字幕插件，通过调用大语言模型(LLM)实现字幕实时翻译功能。

### 功能特点
- 字幕实时翻译
- 支持多种LLM模型
- 与Potplayer无缝集成

### 安装步骤
1. 将插件文件复制到 `Potplayer\Extension\Subtitle\Translate` 目录下
2. 在 `llm.as` 中修改以下配置：
   - `api_key`：您的API密钥
   - `selected_model`：选择的LLM模型
   - `api_url`：API接口地址

### 配置示例
```javascript
// ollama.as 配置示例
api_key = "你的API密钥"
selected_model = "模型名称"
api_url = "https://api.example.com"
```

### 使用要求
- 已安装Potplayer
- 拥有有效的LLM服务API密钥

