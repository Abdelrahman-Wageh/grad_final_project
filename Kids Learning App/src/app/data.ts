export type SubjectId = "math" | "reading" | "science" | "art";

export interface Lesson {
  title: string;
  characterLine: string;
  facts: string[];
  xp: number;
  coins: number;
}

export interface Subject {
  id: SubjectId;
  name: string;
  emoji: string;
  color: string;
  lightColor: string;
  description: string;
  lessons: Lesson[];
}

export interface QuizQuestion {
  question: string;
  options: string[];
  correct: number;
  hint: string;
  subject?: string;
}

export interface BadgeDef {
  id: string;
  emoji: string;
  name: string;
  desc: string;
  check: (u: BadgeCtx) => boolean;
}

export interface BadgeCtx {
  level: number;
  quizzesCompleted: number;
  perfectQuizzes: number;
  streak: number;
  lessonsCompleted: number;
  challengesCompleted: number;
  coins: number;
  subjectsTried: string[];
}

export interface Island {
  id: number;
  name: string;
  theme: string;
  color: string;
  emoji: string;
  x: number;
  y: number;
  subject: SubjectId | null;
  minLevel: number;
}

export interface ShopItem {
  id: string;
  emoji: string;
  name: string;
  cost: number;
}

export const SUBJECTS: Record<SubjectId, Subject> = {
  math: {
    id: "math",
    name: "الرياضيات",
    emoji: "🔢",
    color: "#FFD60A",
    lightColor: "#FFF9D6",
    description: "الأرقام والأشكال والأنماط",
    lessons: [
      {
        title: "جمع الأرقام",
        characterLine: "الجمع مثل دعوة الأصدقاء إلى حفلة! 🎉 ٣ أصدقاء مع ٤ آخرين يساوي ٧ أصدقاء — كلما زادوا كان أفضل! جرّب بنفسك!",
        facts: [
          "علامة + تعني أننا ندمج مجموعتين معاً في مجموعة واحدة",
          "٧ + ٣ = ١٠ — يمكنك دائماً العدّ على أصابعك!",
          "الترتيب لا يهم: ٤ + ٦ يساوي ٦ + ٤ تماماً",
        ],
        xp: 30,
        coins: 10,
      },
      {
        title: "العدّ حتى ١٠٠",
        characterLine: "هل تعلم أن ١٠٠ قرش تساوي جنيهاً واحداً؟ 🪙 اعدد حتى النهاية — حين تصل لـ١٠٠ ستستطيع عدّ أي شيء في العالم!",
        facts: [
          "بعد ٩ يأتي ١٠ — ننتقل إلى مجموعة العشرات الجديدة",
          "٥٠ هو بالضبط منتصف الطريق إلى ١٠٠",
          "العدّ بالعشرات قوة خارقة: ١٠، ٢٠، ٣٠، ٤٠... ١٠٠!",
        ],
        xp: 25,
        coins: 8,
      },
      {
        title: "متعة الأشكال",
        characterLine: "الأشكال تختبئ في كل مكان! 👀 شرائح البيتزا مثلثات، وأوجه الساعات دوائر، وإطارات الأبواب مستطيلات. هل تجد المزيد؟",
        facts: [
          "المثلث له ٣ أضلاع بالضبط و٣ زوايا حادة",
          "المربع له ٤ أضلاع متساوية — كلها بنفس الطول تماماً!",
          "الدائرة مستديرة تماماً وليس لها أي زاوية على الإطلاق",
        ],
        xp: 25,
        coins: 8,
      },
    ],
  },
  reading: {
    id: "reading",
    name: "القراءة",
    emoji: "📖",
    color: "#FF4D6D",
    lightColor: "#FFE0E6",
    description: "قصص وكلمات وحروف",
    lessons: [
      {
        title: "حروف الهجاء المدهشة",
        characterLine: "إليك سراً رائعاً: كل كلمة ستقرؤها مصنوعة من حروف الهجاء! 🤯 هذه الحروف تصنع ملايين الكلمات العربية الجميلة!",
        facts: [
          "اللغة العربية لها ٢٨ حرفاً أساسياً تُبنى منها كل الكلمات",
          "حروف المدّ هي: الألف والواو والياء — توجد في معظم الكلمات",
          "الكلمات العربية تُكتب من اليمين إلى اليسار",
        ],
        xp: 30,
        coins: 10,
      },
      {
        title: "القافية ممتعة",
        characterLine: "قمر، نمر، زمر — كلها تتقافى! 🌙 الكلمات المتقافية تشترك في نفس الصوت الأخير وتجعل القصائد ممتعة للترديد!",
        facts: [
          "الكلمات المتقافية تنتهي بنفس الصوت — وليس دائماً نفس الحروف",
          "'بيت' و'وقت' تتقافيان لأنهما ينتهيان بصوت مماثل",
          "القوافي ساعدت البشر على حفظ القصص لآلاف السنين",
        ],
        xp: 25,
        coins: 8,
      },
      {
        title: "بناء الجمل",
        characterLine: "الجملة هي فكرة كاملة! 📝 'الكلب يركض بسرعة' فيها مَن (الكلب) وماذا يفعل (يركض) وكيف (بسرعة). هذه جملة رائعة!",
        facts: [
          "كل جملة عربية تبدأ بحرف كبير أو بسم الجملة — دائماً!",
          "الجمل تنتهي بنقطة أو علامة تعجب أو علامة استفهام",
          "الجملة المفيدة تحتاج مبتدأ (مَن) وخبراً (الفعل أو الوصف)",
        ],
        xp: 25,
        coins: 8,
      },
    ],
  },
  science: {
    id: "science",
    name: "العلوم",
    emoji: "🔭",
    color: "#06D6A0",
    lightColor: "#D6F8EF",
    description: "الكواكب والحيوانات والحياة",
    lessons: [
      {
        title: "المجموعة الشمسية",
        characterLine: "شمسنا ضخمة جداً — مليون كرة أرضية تسع بداخلها! 🌞 وعطارد الصغير أشد حرارة من أي فرن لأنه قريب جداً منها!",
        facts: [
          "يوجد ٨ كواكب تدور حول شمسنا — بلوتو أصبح كوكباً قزماً",
          "حلقات زحل الرائعة مصنوعة من مليارات قطع الجليد والصخور",
          "يستغرق ضوء الشمس ٨ دقائق بالضبط للوصول إلى الأرض",
        ],
        xp: 35,
        coins: 12,
      },
      {
        title: "كيف تصنع النباتات غذاءها",
        characterLine: "النباتات طهاة محترفون بدون مطبخ! 🌱 تصنع غذاءها من ضوء الشمس والماء والهواء — وتطلق الأكسجين النقي لنتنفسه!",
        facts: [
          "النباتات تمتص ثاني أكسيد الكربون وتطلق الأكسجين الذي نتنفسه",
          "الكلوروفيل يجعل الأوراق خضراء ويلتقط طاقة ضوء الشمس",
          "الجذور تمتد عمقاً في التربة لسحب الماء والمعادن منها",
        ],
        xp: 30,
        coins: 10,
      },
      {
        title: "مملكة الحيوانات",
        characterLine: "وجد العلماء أكثر من ٨ ملايين نوع حيواني على الأرض! 🦁 يصنّفونها: أسماك وطيور وثدييات وزواحف وبرمائيات وحشرات!",
        facts: [
          "الثدييات (ومنها نحن!) ترضع صغارها باللبن الدافئ",
          "الزواحف حيوانات ذوات دم بارد — تحتاج الشمس لتدفئة جسمها",
          "للحشرات دائماً ٦ أرجل بالضبط — العنكبوت له ٨ وليس حشرة!",
        ],
        xp: 30,
        coins: 10,
      },
    ],
  },
  art: {
    id: "art",
    name: "الفنون",
    emoji: "🎨",
    color: "#C77DFF",
    lightColor: "#EDE0FF",
    description: "الألوان والرسم والفنانون",
    lessons: [
      {
        title: "سحر الألوان",
        characterLine: "الأحمر والأصفر والأزرق هي الألوان الأساسية الثلاثة! 🌈 امزج أي اثنين منها وستحصل على لون جديد تماماً — إنه سحر حقيقي!",
        facts: [
          "الأحمر + الأزرق = البنفسجي (لون الملوك والنبلاء!)",
          "الأزرق + الأصفر = الأخضر (كالأوراق والعشب الطازج!)",
          "الأحمر + الأصفر = البرتقالي (كغروب الشمس والبرتقال الحلو!)",
        ],
        xp: 25,
        coins: 8,
      },
      {
        title: "أساسيات الرسم",
        characterLine: "كل رسمة رائعة تبدأ بأشكال بسيطة! ✏️ الوجه مجرد دائرة مع نقاط للعيون. المنزل مربع مع مثلث فوقه. ابدأ ببساطة!",
        facts: [
          "ابدأ دائماً بخطوط قلم رصاص خفيفة يمكن مسحها بسهولة",
          "قسّم أي شيء معقد إلى أشكال بسيطة أولاً",
          "حتى العظيم بيكاسو مارس الأشكال الأساسية لسنوات طويلة!",
        ],
        xp: 25,
        coins: 8,
      },
      {
        title: "فنانون مشهورون",
        characterLine: "رسم فان غوخ 'ليلة مرصّعة بالنجوم' وهو حزين — وأصبحت من أشهر اللوحات في التاريخ! 🌟 الفن يقول ما لا تستطيع الكلمات!",
        facts: [
          "ليوناردو دافنشي رسم الموناليزا وصمّم آلات طائرة أيضاً!",
          "فريدا كالو رسمت ٥٥ صورة ذاتية — رسمت حكايتها الاستثنائية",
          "بانكسي فنان شوارع غامض لا يعرف أحد هويته حتى الآن!",
        ],
        xp: 30,
        coins: 10,
      },
    ],
  },
};

export const QUIZ_DATA: Record<SubjectId, QuizQuestion[]> = {
  math: [
    { question: "كم يساوي ٧ + ٨؟", options: ["١٣", "١٤", "١٥", "١٦"], correct: 2, hint: "ابدأ من ٧ وعُدّ ٨ خطوات للأمام!" },
    { question: "كم يساوي ٢٤ ÷ ٤؟", options: ["٥", "٦", "٧", "٨"], correct: 1, hint: "كم مجموعة من ٤ تسع في ٢٤؟" },
    { question: "كم عدد أضلاع السداسي؟", options: ["٥", "٦", "٧", "٨"], correct: 1, hint: "كلمة سداسي تعني ٦ في اللغة العربية!" },
  ],
  reading: [
    { question: "أي كلمة تتقافى مع 'قمر'؟", options: ["شمس", "نمر", "بيت", "ماء"], correct: 1, hint: "فكّر في حيوان يعيش في الغابة!" },
    { question: "كم عدد حروف العلة في 'كتاب'؟", options: ["١", "٢", "٣", "٤"], correct: 1, hint: "ابحث عن الألف والواو والياء!" },
    { question: "ماذا يوضع في نهاية السؤال؟", options: ["نقطة", "فاصلة", "علامة استفهام", "فاصلة منقوطة"], correct: 2, hint: "إنها خط متعرج فوق نقطة!" },
  ],
  science: [
    { question: "أقرب كوكب إلى الشمس؟", options: ["الزهرة", "الأرض", "عطارد", "المريخ"], correct: 2, hint: "إنه أيضاً أصغر الكواكب!" },
    { question: "ماذا تطلق النباتات في الهواء؟", options: ["ثاني أكسيد الكربون", "النيتروجين", "الأكسجين", "الهيليوم"], correct: 2, hint: "هو ما نتنفسه للبقاء على قيد الحياة!" },
    { question: "كم عدد أرجل العنكبوت؟", options: ["٦", "٨", "١٠", "١٢"], correct: 1, hint: "العنكبوت ليس حشرة — له أرجل أكثر!" },
  ],
  art: [
    { question: "الأحمر + الأزرق = ؟", options: ["الأخضر", "البرتقالي", "البنفسجي", "البني"], correct: 2, hint: "فكّر في الملوك والعنب!" },
    { question: "كم عدد الألوان الأساسية؟", options: ["٢", "٣", "٤", "٥"], correct: 1, hint: "كل الألوان الأخرى تُمزج منها!" },
    { question: "مَن رسم لوحة الموناليزا؟", options: ["بيكاسو", "مونيه", "دافنشي", "رامبرانت"], correct: 2, hint: "كان أيضاً مخترعاً عبقرياً!" },
  ],
};

export const DAILY_QUESTIONS: QuizQuestion[] = [
  { question: "كم يساوي ٦ × ٧؟", options: ["٣٨", "٤٠", "٤٢", "٤٤"], correct: 2, hint: "عُدّ بالسبعات: ٧، ١٤، ٢١... أو ٦ مجموعات من ٧!", subject: "الرياضيات" },
  { question: "مرادف كلمة 'سعيد'؟", options: ["حزين", "مبتهج", "غاضب", "متعب"], correct: 1, hint: "تبدأ بحرف الميم وتشعر كضوء الشمس!", subject: "القراءة" },
  { question: "أكبر كوكب في المجموعة الشمسية؟", options: ["زحل", "الأرض", "نبتون", "المشتري"], correct: 3, hint: "لديه عاصفة حمراء عملاقة أكبر من الأرض!", subject: "العلوم" },
];

export const ALL_BADGES: BadgeDef[] = [
  { id: "first-quiz", emoji: "🎯", name: "أول اختبار", desc: "أكمل أول اختبار لك", check: (u) => u.quizzesCompleted >= 1 },
  { id: "perfect", emoji: "💯", name: "المثالي", desc: "احصل على ٣/٣ في أي اختبار", check: (u) => u.perfectQuizzes >= 1 },
  { id: "streak-3", emoji: "🔥", name: "في اشتعال", desc: "حافظ على ٣ أيام متتالية", check: (u) => u.streak >= 3 },
  { id: "streak-5", emoji: "⚡", name: "البرق", desc: "حافظ على ٥ أيام متتالية", check: (u) => u.streak >= 5 },
  { id: "explorer", emoji: "🧭", name: "المستكشف", desc: "جرّب جميع المواد الأربع", check: (u) => u.subjectsTried.length >= 4 },
  { id: "scholar", emoji: "🎓", name: "العالِم", desc: "أكمل ٦ دروس", check: (u) => u.lessonsCompleted >= 6 },
  { id: "champion", emoji: "🏆", name: "البطل", desc: "ابلغ المستوى ٣", check: (u) => u.level >= 3 },
  { id: "challenger", emoji: "⚔️", name: "المتحدي", desc: "أنهِ تحدي يومياً", check: (u) => u.challengesCompleted >= 1 },
  { id: "collector", emoji: "💎", name: "الجامع", desc: "اكسب ٢٠٠+ عملة", check: (u) => u.coins >= 200 },
  { id: "rocket", emoji: "🚀", name: "الصاروخ", desc: "ابلغ المستوى ٥", check: (u) => u.level >= 5 },
];

export const ISLANDS: Island[] = [
  { id: 1, name: "الحقول المشمسة", theme: "أساسيات الرياضيات", color: "#FFD60A", emoji: "🌻", x: 50, y: 80, subject: "math", minLevel: 1 },
  { id: 2, name: "غابة القصص", theme: "القراءة والكلمات", color: "#FF4D6D", emoji: "🌸", x: 20, y: 62, subject: "reading", minLevel: 1 },
  { id: 3, name: "قمة النجوم", theme: "عالم العلوم", color: "#06D6A0", emoji: "⭐", x: 68, y: 44, subject: "science", minLevel: 2 },
  { id: 4, name: "وادي قوس قزح", theme: "الفن والألوان", color: "#C77DFF", emoji: "🌈", x: 28, y: 26, subject: "art", minLevel: 3 },
  { id: 5, name: "المعبد الغامض", theme: "المغامرة الكبرى", color: "#4CC9F0", emoji: "🏛️", x: 58, y: 10, subject: null, minLevel: 5 },
];

export const SHOP_AVATARS: ShopItem[] = [
  { id: "fox", emoji: "🦊", name: "الثعلب", cost: 0 },
  { id: "bunny", emoji: "🐰", name: "الأرنب", cost: 100 },
  { id: "dragon", emoji: "🐲", name: "التنين", cost: 200 },
  { id: "owl", emoji: "🦉", name: "البومة", cost: 150 },
  { id: "tiger", emoji: "🐯", name: "النمر", cost: 180 },
];

export const SHOP_HATS: ShopItem[] = [
  { id: "hat-none", emoji: "✨", name: "بدون", cost: 0 },
  { id: "hat-crown", emoji: "👑", name: "التاج", cost: 80 },
  { id: "hat-wizard", emoji: "🎩", name: "قبعة الساحر", cost: 60 },
  { id: "hat-cap", emoji: "🧢", name: "الكاب", cost: 40 },
  { id: "hat-party", emoji: "🎊", name: "قبعة الحفلة", cost: 30 },
];

export const SHOP_OUTFITS: ShopItem[] = [
  { id: "outfit-default", emoji: "👕", name: "الافتراضي", cost: 0 },
  { id: "outfit-astronaut", emoji: "👨‍🚀", name: "رائد الفضاء", cost: 120 },
  { id: "outfit-knight", emoji: "🛡️", name: "الفارس", cost: 100 },
  { id: "outfit-scientist", emoji: "🥼", name: "العالِم", cost: 90 },
  { id: "outfit-wizard", emoji: "🧙", name: "الساحر", cost: 110 },
];

export const STUDY_TIME_DATA = [
  { day: "إث", minutes: 20 },
  { day: "ثل", minutes: 35 },
  { day: "أر", minutes: 15 },
  { day: "خم", minutes: 42 },
  { day: "جم", minutes: 28 },
  { day: "سب", minutes: 55 },
  { day: "أح", minutes: 24 },
];
