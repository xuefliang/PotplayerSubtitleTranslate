/*
    Real-time subtitle translation for PotPlayer using OpenAI ChatGPT API
*/

string GetTitle() {
    return "{$CP950=本地 AI 翻译$}{$CP0=Local AI Translate$}";
}

string GetVersion() {
    return "1.6";
}

string GetDesc() {
    return "{$CP950=使用本地 AI 的实时字幕翻译$}{$CP0=Real-time subtitle translation using Local AI$}";
}

string GetLoginTitle() {
    return "{$CP950=本地 AI 模型配置$}{$CP0=Local AI Model Configuration$}";
}

string GetLoginDesc() {
    return "{$CP950=请输入模型名称和API地址$}{$CP0=Please enter the model name and API address.$}";
}

string GetUserText() {
    return "{$CP950=模型名称 (当前: " + selected_model + ")$}{$CP0=Model Name (Current: " + selected_model + ")$}";
}

string GetPasswordText() {
    return "{$CP950=API 密钥:$}{$CP0=API Key:$}";
}

string GetApiUrlText() {
    return "{$CP950=API 地址 (当前: " + api_url + ")$}{$CP0=API URL (Current: " + api_url + ")$}";
}

string api_key = "*****************";
string selected_model = "Qwen/Qwen2.5-Coder-7B-Instruct";
string api_url = "https://api.siliconflow.cn/v1/chat/completions";
string UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)";

array<string> LangTable = 
{
    "Auto", "af", "sq", "am", "ar", "hy", "az", "eu", "be", "bn", "bs", "bg", "ca",
    "ceb", "ny", "zh-CN",
    "zh-TW", "co", "hr", "cs", "da", "nl", "en", "eo", "et", "tl", "fi", "fr",
    "fy", "gl", "ka", "de", "el", "gu", "ht", "ha", "haw", "he", "hi", "hmn", "hu", "is", "ig", "id", "ga", "it", "ja", "jw", "kn", "kk", "km",
    "ko", "ku", "ky", "lo", "la", "lv", "lt", "lb", "mk", "ms", "mg", "ml", "mt", "mi", "mr", "mn", "my", "ne", "no", "ps", "fa", "pl", "pt",
    "pa", "ro", "ru", "sm", "gd", "sr", "st", "sn", "sd", "si", "sk", "sl", "so", "es", "su", "sw", "sv", "tg", "ta", "te", "th", "tr", "uk",
    "ur", "uz", "vi", "cy", "xh", "yi", "yo", "zu"
};

array<string> GetSrcLangs() {
    array<string> ret = LangTable;
    return ret;
}

array<string> GetDstLangs() {
    array<string> ret = LangTable;
    return ret;
}

string ServerLogin(string User, string Pass, string ApiUrl) {
    selected_model = User.Trim();
    api_key = Pass.Trim();
    api_url = ApiUrl.Trim();

    selected_model.MakeLower();

    if (selected_model.empty()) {
        HostPrintUTF8("{$CP950=模型名称未输入$}{$CP0=Model name not entered.$}\n");
        selected_model = "Qwen/Qwen2.5-Coder-7B-Instruct";
    }

    if (api_url.empty()) {
        HostPrintUTF8("{$CP950=API 地址未输入$}{$CP0=API URL not entered.$}\n");
        api_url = "https://api.siliconflow.cn/v1/chat/completions";
    }

    HostSaveString("api_key", api_key);
    HostSaveString("selected_model", selected_model);
    HostSaveString("api_url", api_url);

    HostPrintUTF8("{$CP950=设置已成功保存$}{$CP0=Settings successfully saved.$}\n");
    return "200 ok";
}

void ServerLogout() {
    api_key = "sk-bzkcqonrkcphoqajerhpdrledfkpcaezavxstyhnoyjdlwja";
    selected_model = "Qwen/Qwen2.5-Coder-7B-Instruct"; 
    api_url = "https://api.siliconflow.cn/v1/chat/completions";
    HostSaveString("api_key", api_key);
    HostSaveString("selected_model", selected_model);
    HostSaveString("api_url", api_url);
    HostPrintUTF8("{$CP950=已成功登出$}{$CP0=Successfully logged out.$}\n");
}

string JsonEscape(const string &in input) {
    string output = input;
    output.replace("\\", "\\\\");
    output.replace("\"", "\\\"");
    output.replace("\n", "\\n");
    output.replace("\r", "\\r");
    output.replace("\t", "\\t");
    return output;
}

string Translate(string Text, string &in SrcLang, string &in DstLang) {
    selected_model = HostLoadString("selected_model", "Qwen/Qwen2.5-Coder-7B-Instruct");
    api_url = HostLoadString("api_url", "https://api.siliconflow.cn/v1/chat/completions");
    api_key = HostLoadString("api_key", "sk-bzkcqonrkcphoqajerhpdrledfkpcaezavxstyhnoyjdlwja");

    if (DstLang.empty() || DstLang == "{$CP950=自动检测$}{$CP0=Auto Detect$}") {
        HostPrintUTF8("{$CP950=目标语言未指定$}{$CP0=Target language not specified.$}\n");
        return "";
    }

    string UNICODE_RLE = "\u202B";

    if (SrcLang.empty() || SrcLang == "{$CP950=自动检测$}{$CP0=Auto Detect$}") {
        SrcLang = "";
    }

    string prompt = "Translate the following text";
    if (!SrcLang.empty()) {
        prompt += " from " + SrcLang;
    }
    prompt += " to " + DstLang + ":\n\n" + Text;

    string escapedPrompt = JsonEscape(prompt);
    string requestData = "{\"model\":\"" + selected_model + "\",\"messages\":[{\"role\":\"user\",\"content\":\"" + escapedPrompt + "\"}]}";
    string headers = "Content-Type: application/json\nAuthorization: Bearer " + api_key;

    string response = HostUrlGetString(api_url, UserAgent, headers, requestData);
    if (response.empty()) {
        HostPrintUTF8("{$CP950=翻译请求失败$}{$CP0=Translation request failed.$}\n");
        return "";
    }

    JsonReader Reader;
    JsonValue Root;
    if (!Reader.parse(response, Root)) {
        HostPrintUTF8("{$CP950=无法解析 API 响应$}{$CP0=Failed to parse API response.$}\n");
        return "";
    }

    JsonValue choices = Root["choices"];
    if (choices.isArray() && choices[0]["message"]["content"].isString()) {
        string translatedText = choices[0]["message"]["content"].asString();
        if (DstLang == "fa" || DstLang == "ar" || DstLang == "he") {
            translatedText = UNICODE_RLE + translatedText;
        }
        SrcLang = "UTF8";
        DstLang = "UTF8";
        return translatedText;
    }

    HostPrintUTF8("{$CP950=翻译失败$}{$CP0=Translation failed.$}\n");
    return "";
}

void OnInitialize() {
    HostPrintUTF8("{$CP950=ChatGPT 翻译插件已加载$}{$CP0=ChatGPT translation plugin loaded.$}\n");
    api_key = HostLoadString("api_key", "sk-bzkcqonrkcphoqajerhpdrledfkpcaezavxstyhnoyjdlwja");
    selected_model = HostLoadString("selected_model", "Qwen/Qwen2.5-Coder-7B-Instruct");
    api_url = HostLoadString("api_url", "https://api.siliconflow.cn/v1/chat/completions");
}

void OnFinalize() {
    HostPrintUTF8("{$CP950=ChatGPT 翻译插件已卸载$}{$CP0=ChatGPT translation plugin unloaded.$}\n");
}
