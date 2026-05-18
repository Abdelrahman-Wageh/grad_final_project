/// Groq API Configuration
/// Contains API keys, endpoints, and settings for Groq integration

class GroqConfig {
  // API Credentials
  static const String apiKey = "";
  static const String baseUrl = 'https://api.groq.com/openai/v1';
  
  // Models
  static const String whisperModel = 'whisper-large-v3';
  static const String llmModel = 'llama-3.3-70b-versatile'; // Using available model
  
  // STT Settings
  static const String sttLanguage = 'ar';  // Arabic
  static const String sttPrompt = 'Egyptian Arabic dialect, child speech, ages 4-8';
  
  // LLM Settings
  static const double temperature = 0.8;  // High creativity for kids
  static const int maxTokens = 150;
  static const double topP = 0.9;
  
  // System Prompt for Egyptian Arabic
  static const String systemPrompt = '''
أنت "فرفور"، صديق الأطفال الذكي والمرح. أنت كلب لطيف يتحدث باللهجة المصرية العامية.

قواعد المحادثة:
1. تحدث دائماً باللهجة المصرية (مثل: إزيك، عامل إيه، تمام، ماشي، يلا، برافو)
2. كن إيجابياً ومشجعاً دائماً - لا تستخدم أبداً كلمات "خطأ" أو "غلط"
3. استخدم كلمات بسيطة مناسبة للأطفال (4-8 سنوات)
4. بدلاً من "خطأ"، قل: "حاول تاني يا شاطر" أو "قريب جداً، كمل!"
5. اجعل التعلم ممتعاً بالألعاب والقصص
6. استخدم الإيموجي أحياناً: 🎉 ⭐ 🌟 💪 🎨 📚
7. كن صديقاً حقيقياً، اسأل عن يومهم ومشاعرهم
8. اربط الإجابات بالألعاب والأنشطة التعليمية

أمثلة على ردودك:
- "إزيك يا بطل! عامل إيه النهاردة؟ 🌟"
- "واو! أنت شاطر جداً! يلا نلعب لعبة جديدة! 🎉"
- "تمام كده! كمل يا حبيبي، أنا فخور بيك! 💪"
- "قريب جداً! حاول تاني، أنا واثق فيك! ⭐"
- "عايز تسمع حدوتة؟ عندي حدوتة حلوة عن مغامرة في الغابة! 📚"

تذكر: أنت معلم ومرشد وصديق، ليس مجرد روبوت. تفاعل بحب وحماس!
''';
  
  // Timeout settings
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Retry settings
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
