# Smartino Super-App - Assets & Graphics Guide

**Date**: January 26, 2026  
**Purpose**: Complete guide for graphics, sounds, animations, and asset management  
**Quality Standard**: Unity-level polish and professionalism

---

## 🎨 GRAPHICS ASSETS

### Character Assets (Farfour - فرفور)

**Location**: `mobile_app/assets/characters/farfour/`

**Required Assets**:
1. **idle.png** - Default standing pose (512x512px)
2. **happy.png** - Smiling, cheerful expression (512x512px)
3. **excited.png** - Jumping with joy (512x512px)
4. **thinking.png** - Hand on chin, pondering (512x512px)
5. **sad.png** - Gentle sad expression (512x512px)
6. **celebrating.png** - Arms raised, confetti (512x512px)
7. **speaking.png** - Mouth open, animated (512x512px)
8. **sleeping.png** - Eyes closed, peaceful (512x512px)

**Design Guidelines**:
- **Style**: Cute, friendly, Egyptian-inspired character
- **Colors**: Warm Egyptian palette (sandy browns, sky blues, golden accents)
- **Format**: PNG with transparency
- **Resolution**: 512x512px @2x, 1024x1024px @3x
- **Inspiration**: Antura's friendly dog character but adapted to Egyptian culture
- **Character Traits**: Big expressive eyes, friendly smile, Egyptian clothing/accessories

---

### Background Assets

**Location**: `mobile_app/assets/images/backgrounds/`

**Required Backgrounds**:

1. **pyramids.png** (1920x1080px)
   - Egyptian pyramids at sunset
   - Warm golden hour lighting
   - Desert sand dunes
   - Clear blue sky

2. **cairo.png** (1920x1080px)
   - Cairo cityscape
   - Nile River visible
   - Modern buildings with traditional architecture
   - Vibrant, colorful

3. **nile.png** (1920x1080px)
   - Nile River scene
   - Felucca boats
   - Palm trees
   - Peaceful water

4. **desert.png** (1920x1080px)
   - Egyptian desert
   - Sand dunes
   - Oasis in distance
   - Blue sky with few clouds

5. **garden.png** (1920x1080px)
   - Egyptian garden
   - Colorful flowers
   - Palm trees
   - Fountain

6. **sky.png** (1920x1080px)
   - Clear blue sky
   - Fluffy white clouds
   - Suitable for any game
   - Light, cheerful

**Design Guidelines**:
- **Style**: Cartoon/illustrated, not photorealistic
- **Colors**: Vibrant, saturated, child-friendly
- **Format**: PNG or JPG
- **Resolution**: 1920x1080px minimum
- **Inspiration**: Antura's colorful, engaging backgrounds

---

### Game Assets

#### Letter Balloons Game

**Location**: `mobile_app/assets/images/games/balloons/`

**Required Assets**:
1. **balloon_red.png** (256x320px) - Red balloon with string
2. **balloon_blue.png** (256x320px) - Blue balloon with string
3. **balloon_green.png** (256x320px) - Green balloon with string
4. **balloon_yellow.png** (256x320px) - Yellow balloon with string
5. **balloon_purple.png** (256x320px) - Purple balloon with string
6. **balloon_pink.png** (256x320px) - Pink balloon with string

**Design Guidelines**:
- Glossy, shiny balloon texture
- Visible string/ribbon
- Slight 3D effect
- Transparent background
- Shadow underneath

#### Fast Crowd Game

**Location**: `mobile_app/assets/images/games/crowd/`

**Required Assets**:
1. **card.png** (200x280px) - Letter card template
2. **background.png** (1920x1080px) - Crowd scene background

**Design Guidelines**:
- Cards: Clean, rounded corners, shadow
- Background: Busy but not distracting
- Egyptian market/bazaar theme

#### Missing Letter Game

**Location**: `mobile_app/assets/images/games/missing_letter/`

**Required Assets**:
1. **slot.png** (120x160px) - Empty letter slot
2. **tile.png** (120x160px) - Letter tile

**Design Guidelines**:
- Slot: Dashed border, subtle shadow
- Tile: Solid, colorful, 3D effect
- Clear visual distinction

#### Mixed Letters Game

**Location**: `mobile_app/assets/images/games/mixed_letters/`

**Required Assets**:
1. **tile.png** (100x100px) - Draggable letter tile
2. **slot.png** (100x100px) - Answer slot

**Design Guidelines**:
- Tiles: Colorful, tactile appearance
- Slots: Clear, inviting
- Drag-and-drop visual feedback

#### Reading Game

**Location**: `mobile_app/assets/images/games/reading/`

**Required Assets**:
1. **book_open.png** (512x512px) - Open book illustration
2. **book_closed.png** (512x512px) - Closed book illustration

**Design Guidelines**:
- Storybook style
- Warm, inviting colors
- Egyptian patterns on cover

---

### UI Elements

**Location**: `mobile_app/assets/images/ui/`

**Required Assets**:

1. **Stars**:
   - star_empty.png (128x128px) - Outline only
   - star_filled.png (128x128px) - Solid color
   - star_gold.png (128x128px) - Golden, shiny

2. **Buttons**:
   - button_normal.png (300x100px) - Default state
   - button_pressed.png (300x100px) - Pressed state
   - button_disabled.png (300x100px) - Disabled state

3. **Icons** (128x128px each):
   - game.png - Game controller icon
   - story.png - Book icon
   - friend.png - Chat bubble icon
   - parent.png - Parent/adult icon
   - settings.png - Gear icon

**Design Guidelines**:
- Consistent style across all UI elements
- Clear, recognizable icons
- Appropriate for children
- High contrast for visibility

---

### Particle Effects

**Location**: `mobile_app/assets/images/particles/`

**Required Assets**:
1. **confetti.png** (64x64px) - Confetti piece
2. **star.png** (64x64px) - Star particle
3. **sparkle.png** (64x64px) - Sparkle effect
4. **heart.png** (64x64px) - Heart particle

**Design Guidelines**:
- Small, lightweight
- Transparent background
- Bright, vibrant colors
- Suitable for particle systems

---

## 🔊 SOUND ASSETS

### Music

**Location**: `mobile_app/assets/sounds/music/`

**Required Tracks**:

1. **menu.mp3** (2-3 minutes, loopable)
   - Upbeat, cheerful
   - Egyptian musical elements
   - Child-friendly
   - 128kbps MP3

2. **game.mp3** (2-3 minutes, loopable)
   - Energetic, motivating
   - Maintains focus
   - Not distracting
   - 128kbps MP3

3. **story.mp3** (2-3 minutes, loopable)
   - Calm, soothing
   - Storytelling atmosphere
   - Egyptian instruments
   - 128kbps MP3

4. **victory.mp3** (30 seconds)
   - Triumphant, celebratory
   - Builds excitement
   - Reward feeling
   - 128kbps MP3

**Design Guidelines**:
- All tracks must loop seamlessly
- Volume normalized to -14 LUFS
- No sudden loud parts
- Egyptian musical influences (oud, qanun, tabla)
- Child-appropriate tempo and energy

---

### Sound Effects - UI

**Location**: `mobile_app/assets/sounds/sfx/`

**Required SFX**:

1. **tap.mp3** - Quick tap sound (0.1s)
2. **button.mp3** - Button press sound (0.2s)
3. **swipe.mp3** - Swipe gesture sound (0.3s)
4. **pop.mp3** - Pop/bubble sound (0.2s)

**Design Guidelines**:
- Short duration (< 0.5s)
- Clear, distinct sounds
- Not annoying with repetition
- 64kbps MP3

---

### Sound Effects - Game

**Location**: `mobile_app/assets/sounds/sfx/`

**Required SFX**:

1. **correct.mp3** - Correct answer (0.5s)
   - Positive, rewarding
   - Musical chime
   - Uplifting

2. **wrong.mp3** - Wrong answer (0.3s)
   - Gentle, not harsh
   - Encouraging to try again
   - Soft buzzer

3. **star.mp3** - Star earned (0.8s)
   - Magical, sparkly
   - Reward feeling
   - Ascending notes

4. **celebration.mp3** - Big celebration (2s)
   - Confetti, cheering
   - Victory fanfare
   - Exciting

5. **balloon_pop.mp3** - Balloon popping (0.2s)
   - Satisfying pop
   - Not scary
   - Fun

6. **letter_place.mp3** - Letter placement (0.2s)
   - Click/snap sound
   - Tactile feedback
   - Satisfying

7. **word_complete.mp3** - Word completed (1s)
   - Achievement sound
   - Musical flourish
   - Rewarding

**Design Guidelines**:
- Clear audio feedback
- Positive reinforcement
- Never harsh or scary
- 64kbps MP3

---

### Voice Lines (Egyptian Arabic)

**Location**: `mobile_app/assets/sounds/voices/`

**Required Voice Lines**:

1. **bravo.mp3** - "برافو!" (Bravo!)
2. **excellent.mp3** - "ممتاز!" (Excellent!)
3. **try_again.mp3** - "حاول تاني" (Try again)
4. **great.mp3** - "رائع!" (Great!)
5. **well_done.mp3** - "أحسنت!" (Well done!)
6. **lets_play.mp3** - "يلا نلعب!" (Let's play!)
7. **hello.mp3** - "إزيك يا بطل؟" (Hello champion!)

**Voice Guidelines**:
- **Gender**: Male or female, child-friendly
- **Accent**: Egyptian Arabic dialect
- **Tone**: Warm, encouraging, enthusiastic
- **Quality**: Professional recording, clear
- **Format**: MP3, 96kbps
- **Duration**: 1-2 seconds each
- **Alternative**: Use ElevenLabs TTS with API key provided

---

## 🎬 ANIMATIONS

### Lottie Animations

**Location**: `mobile_app/assets/animations/`

**Required Animations**:

1. **confetti.json** - Confetti explosion
2. **stars.json** - Stars appearing
3. **fireworks.json** - Fireworks display
4. **sparkles.json** - Sparkle effects
5. **loading.json** - Loading spinner
6. **success.json** - Success checkmark
7. **error.json** - Error indicator

**Design Guidelines**:
- Lottie JSON format
- 60 FPS
- Optimized file size (< 100KB)
- Loopable where appropriate
- Colorful, engaging

---

### Character Animations

**Location**: `mobile_app/assets/animations/farfour/`

**Required Animations**:

1. **walk.json** - Walking cycle
2. **jump.json** - Jumping motion
3. **dance.json** - Dancing celebration
4. **wave.json** - Waving hello

**Design Guidelines**:
- Smooth, natural motion
- 30-60 FPS
- Loopable
- Matches character design
- Expressive, lively

---

## 📁 ASSET ORGANIZATION

### Directory Structure

```
mobile_app/assets/
├── characters/
│   └── farfour/
│       ├── idle.png
│       ├── happy.png
│       ├── excited.png
│       ├── thinking.png
│       ├── sad.png
│       ├── celebrating.png
│       ├── speaking.png
│       └── sleeping.png
├── images/
│   ├── backgrounds/
│   │   ├── pyramids.png
│   │   ├── cairo.png
│   │   ├── nile.png
│   │   ├── desert.png
│   │   ├── garden.png
│   │   └── sky.png
│   ├── games/
│   │   ├── balloons/
│   │   ├── crowd/
│   │   ├── missing_letter/
│   │   ├── mixed_letters/
│   │   └── reading/
│   ├── ui/
│   │   ├── star_empty.png
│   │   ├── star_filled.png
│   │   ├── star_gold.png
│   │   ├── button_normal.png
│   │   ├── button_pressed.png
│   │   └── button_disabled.png
│   ├── icons/
│   │   ├── game.png
│   │   ├── story.png
│   │   ├── friend.png
│   │   ├── parent.png
│   │   └── settings.png
│   └── particles/
│       ├── confetti.png
│       ├── star.png
│       ├── sparkle.png
│       └── heart.png
├── sounds/
│   ├── music/
│   │   ├── menu.mp3
│   │   ├── game.mp3
│   │   ├── story.mp3
│   │   └── victory.mp3
│   ├── sfx/
│   │   ├── tap.mp3
│   │   ├── button.mp3
│   │   ├── correct.mp3
│   │   ├── wrong.mp3
│   │   ├── star.mp3
│   │   ├── celebration.mp3
│   │   ├── balloon_pop.mp3
│   │   ├── letter_place.mp3
│   │   └── word_complete.mp3
│   ├── character/
│   │   ├── farfour_happy.mp3
│   │   ├── farfour_excited.mp3
│   │   ├── farfour_thinking.mp3
│   │   └── farfour_sad.mp3
│   └── voices/
│       ├── bravo.mp3
│       ├── excellent.mp3
│       ├── try_again.mp3
│       ├── great.mp3
│       ├── well_done.mp3
│       ├── lets_play.mp3
│       └── hello.mp3
└── animations/
    ├── confetti.json
    ├── stars.json
    ├── fireworks.json
    ├── sparkles.json
    ├── loading.json
    ├── success.json
    ├── error.json
    └── farfour/
        ├── walk.json
        ├── jump.json
        ├── dance.json
        └── wave.json
```

---

## 🎨 DESIGN SPECIFICATIONS

### Color Palette

**Primary Colors**:
- Egyptian Blue: #1E88E5
- Warm Orange: #FF9800
- Sandy Brown: #D4A574
- Sky Blue: #87CEEB
- Golden Yellow: #FFD700

**Secondary Colors**:
- Success Green: #4CAF50
- Warning Amber: #FFC107
- Error Red: #F44336
- Purple: #9C27B0
- Pink: #E91E63

**Neutral Colors**:
- White: #FFFFFF
- Light Gray: #F5F5F5
- Medium Gray: #9E9E9E
- Dark Gray: #424242
- Black: #000000

---

### Typography

**Arabic Font**: Cairo (Google Fonts)
- Display: 57px, Bold
- Headline: 32px, Bold
- Title: 22px, Medium
- Body: 16px, Regular

**English Font**: Poppins (Google Fonts)
- Same sizes as Arabic

---

### Animation Timing

**Standard Durations**:
- Quick: 150ms (tap feedback)
- Normal: 300ms (transitions)
- Slow: 500ms (emphasis)
- Very Slow: 800ms (celebrations)

**Easing Curves**:
- Ease Out: UI appearing
- Ease In: UI disappearing
- Ease In Out: Smooth transitions
- Elastic: Playful bounces
- Bounce: Celebration effects

---

## 🛠️ IMPLEMENTATION

### pubspec.yaml Configuration

```yaml
flutter:
  assets:
    # Characters
    - assets/characters/farfour/
    
    # Backgrounds
    - assets/images/backgrounds/
    
    # Game assets
    - assets/images/games/balloons/
    - assets/images/games/crowd/
    - assets/images/games/missing_letter/
    - assets/images/games/mixed_letters/
    - assets/images/games/reading/
    
    # UI
    - assets/images/ui/
    - assets/images/icons/
    - assets/images/particles/
    
    # Sounds
    - assets/sounds/music/
    - assets/sounds/sfx/
    - assets/sounds/character/
    - assets/sounds/voices/
    
    # Animations
    - assets/animations/
    - assets/animations/farfour/
```

---

## 📝 ASSET CREATION TOOLS

### Recommended Tools

**Graphics**:
- Adobe Illustrator (vector graphics)
- Adobe Photoshop (raster graphics)
- Figma (UI design)
- Procreate (iPad illustration)
- Aseprite (pixel art, if needed)

**Audio**:
- Audacity (free audio editing)
- Adobe Audition (professional)
- GarageBand (Mac/iOS)
- FL Studio (music production)

**Animation**:
- Adobe After Effects + Bodymovin (Lottie)
- LottieFiles (Lottie creation)
- Spine (2D skeletal animation)
- DragonBones (free alternative)

**Voice Recording**:
- Professional studio (recommended)
- ElevenLabs API (TTS alternative)
- Home recording with good microphone

---

## 🎯 QUALITY CHECKLIST

### Graphics
- [ ] All images have transparent backgrounds where needed
- [ ] Consistent art style across all assets
- [ ] Proper resolution (@2x, @3x for iOS)
- [ ] Optimized file sizes
- [ ] No copyright issues

### Audio
- [ ] All sounds normalized to consistent volume
- [ ] No clipping or distortion
- [ ] Proper fade in/out
- [ ] Loopable tracks loop seamlessly
- [ ] Compressed appropriately (MP3)

### Animations
- [ ] Smooth, no jittering
- [ ] Optimized file size
- [ ] Proper frame rate (30-60 FPS)
- [ ] Loopable where appropriate
- [ ] Works on all devices

---

## 🚀 NEXT STEPS

### Asset Creation Priority

**Phase 1 - Critical** (Week 1):
1. Farfour character (8 poses)
2. Basic UI elements (stars, buttons)
3. Essential sound effects (correct, wrong, tap)
4. One background (sky)

**Phase 2 - Important** (Week 2):
1. Game-specific assets (balloons, cards, tiles)
2. All backgrounds
3. Music tracks
4. Voice lines (or use ElevenLabs)

**Phase 3 - Polish** (Week 3):
1. Particle effects
2. Lottie animations
3. Character animations
4. Additional sound effects

---

## 💡 TIPS & BEST PRACTICES

### Graphics
- Use vector graphics where possible for scalability
- Keep file sizes small for faster loading
- Test on actual devices, not just emulator
- Use consistent lighting and shadows
- Make characters expressive and friendly

### Audio
- Record in quiet environment
- Use pop filter for voice recording
- Test on device speakers, not just headphones
- Keep music volume lower than SFX
- Avoid sudden loud sounds

### Animations
- Less is more - don't over-animate
- Match animation speed to user expectations
- Use easing for natural motion
- Test on low-end devices
- Provide option to reduce animations

---

## 📞 RESOURCES

### Free Asset Sources
- **Graphics**: Freepik, Flaticon, unDraw
- **Sounds**: Freesound.org, Zapsplat
- **Music**: Incompetech, Purple Planet
- **Fonts**: Google Fonts
- **Icons**: Material Icons, Font Awesome

### Paid Asset Sources
- **Graphics**: Envato Elements, Creative Market
- **Sounds**: AudioJungle, Epidemic Sound
- **Music**: Artlist, Soundstripe
- **Animations**: LottieFiles Pro

### Egyptian Cultural Resources
- Egyptian Museum archives
- Traditional Egyptian art references
- Egyptian music samples
- Arabic calligraphy references

---

**Status**: Asset specifications complete  
**Next Step**: Begin asset creation or sourcing  
**Priority**: Critical assets first (character, UI, basic sounds)

**Remember**: Quality over quantity. Better to have fewer high-quality assets than many low-quality ones!

