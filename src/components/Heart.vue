<template>
  <div
    class="heart-container"
    @click="createHeart"
    @touchstart.prevent="handleTouchStart"
  >
    <!-- 爱心动画元素 -->
    <div
      v-for="heart in hearts"
      :key="heart.id"
      class="heart"
      :style="{
        left: heart.x + 'px',
        top: heart.y + 'px',
        fontSize: heart.size + 'px',
        color: heart.color,
        animation: `heartFloat 500ms ease-out forwards`,
      }"
      @animationend="removeHeart(heart.id)"
    >
      {{ heart.icon }}
    </div>

    <!-- 示例内容区域 -->
    <div class="content">
      <h1 class="title">💖 点击屏幕试试看 💖</h1>
      <p class="subtitle">在任何地方点击都会出现可爱的爱心哦～</p>
      <p class="duration-info">每个爱心只会停留 0.5 秒就消失啦 ✨</p>
      <div class="demo-area">
        <div class="cute-box">
          <span class="box-emoji">🌸</span>
          <p>这里是示例内容</p>
          <span class="box-emoji">🎀</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from "vue";

interface Heart {
  id: number;
  x: number;
  y: number;
  icon: string;
  color: string;
  size: number;
}

const hearts = ref<Heart[]>([]);
let heartId = 0;

// 可爱的爱心图标数组
const heartIcons = [
  "💕",
  "💖",
  "💗",
  "💓",
  "💝",
  "💘",
  "💞",
  "💟",
  "❤️",
  "🧡",
  "💛",
  "💚",
  "💙",
  "💜",
  "🤍",
  "🖤",
  "❣️",
  "💋",
  "🌸",
  "🌺",
  "🌻",
  "🌷",
  "🌹",
  "✨",
  "⭐",
  "🎀",
  "🦋",
  "🌟",
  "💐",
  "🎊",
];

// 粉色系颜色数组
const pinkColors = [
  "#FF69B4",
  "#FF1493",
  "#FFB6C1",
  "#FFC0CB",
  "#FFCCCB",
  "#FF91A4",
  "#FF8FA3",
  "#FF6B9D",
  "#F06292",
  "#E91E63",
  "#EC407A",
  "#F48FB1",
  "#FCE4EC",
  "#F8BBD9",
  "#E1BEE7",
  "#BA68C8",
  "#FF6EC7",
  "#FF85D1",
  "#FFA3E0",
  "#FFB3E6",
];

// 创建爱心效果
const createHeart = (event: MouseEvent | TouchEvent) => {
  const clientX =
    "touches" in event ? event.touches[0]?.clientX : event.clientX;
  const clientY =
    "touches" in event ? event.touches[0]?.clientY : event.clientY;

  if (clientX === undefined || clientY === undefined) return;

  // 创建1-2个爱心
  const heartCount = Math.floor(Math.random() * 2) + 1;

  for (let i = 0; i < heartCount; i++) {
    const heart: Heart = {
      id: heartId++,
      x: clientX + (Math.random() - 0.5) * 80, // 随机偏移 -40px 到 +40px
      y: clientY + (Math.random() - 0.5) * 40, // 随机偏移 -20px 到 +20px
      icon: heartIcons[Math.floor(Math.random() * heartIcons.length)],
      color: pinkColors[Math.floor(Math.random() * pinkColors.length)],
      size: Math.random() * 15 + 25, // 25-40px
    };

    hearts.value.push(heart);

    // 500毫秒后自动移除（备用清理机制）
    setTimeout(() => {
      removeHeart(heart.id);
    }, 500);

    // 延迟添加，创造连续效果
    if (i > 0) {
      setTimeout(() => {}, i * 50);
    }
  }
};

// 处理触摸事件
const handleTouchStart = (event: TouchEvent) => {
  // 阻止默认行为，避免页面滚动和缩放
  event.preventDefault();

  // 处理多点触控
  for (let i = 0; i < event.touches.length; i++) {
    const touch = event.touches[i];
    createHeartAtPosition(touch.clientX, touch.clientY);
  }
};

// 在指定位置创建爱心
const createHeartAtPosition = (x: number, y: number) => {
  const heart: Heart = {
    id: heartId++,
    x: x + (Math.random() - 0.5) * 60,
    y: y + (Math.random() - 0.5) * 30,
    icon: heartIcons[Math.floor(Math.random() * heartIcons.length)],
    color: pinkColors[Math.floor(Math.random() * pinkColors.length)],
    size: Math.random() * 15 + 25,
  };

  hearts.value.push(heart);

  // 500毫秒后自动移除
  setTimeout(() => {
    removeHeart(heart.id);
  }, 500);
};

// 移除爱心
const removeHeart = (id: number) => {
  const index = hearts.value.findIndex((heart) => heart.id === id);
  if (index > -1) {
    hearts.value.splice(index, 1);
  }
};

// 清理所有爱心（紧急清理机制）
const clearAllHearts = () => {
  hearts.value = [];
};

// 防止爱心堆积过多
const limitHearts = () => {
  if (hearts.value.length > 20) {
    hearts.value = hearts.value.slice(-10); // 只保留最新的10个
  }
};

let limitTimer: number;

onMounted(() => {
  // 每100毫秒检查一次爱心数量
  limitTimer = setInterval(limitHearts, 100);

  // 添加页面可见性变化监听，页面隐藏时清理爱心
  document.addEventListener("visibilitychange", () => {
    if (document.hidden) {
      clearAllHearts();
    }
  });
});

onUnmounted(() => {
  if (limitTimer) {
    clearInterval(limitTimer);
  }
  clearAllHearts();
});
</script>

<style lang="less" scoped>
.heart-container {
  position: relative;
  width: 100%;
  min-height: 100vh;
  background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #fecfef 100%);
  overflow: hidden;
  cursor: pointer;
  touch-action: manipulation;
  user-select: none;
  -webkit-user-select: none;
  -webkit-touch-callout: none;
  -webkit-tap-highlight-color: transparent;
}

.heart {
  position: fixed;
  pointer-events: none;
  z-index: 9999;
  font-size: 30px;
  transform-origin: center;
  text-shadow: 0 0 8px rgba(255, 255, 255, 0.8),
    0 0 15px rgba(255, 105, 180, 0.6);
  filter: drop-shadow(0 2px 4px rgba(255, 105, 180, 0.4));
  will-change: transform, opacity; // 优化性能
}

.content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  padding: 20px;
  text-align: center;
  position: relative;
  z-index: 1;
}

.title {
  font-size: 28px;
  color: #fff;
  margin-bottom: 15px;
  text-shadow: 0 2px 10px rgba(255, 105, 180, 0.8);
  animation: titlePulse 2s ease-in-out infinite alternate;
}

.subtitle {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 10px;
  text-shadow: 0 1px 5px rgba(255, 105, 180, 0.5);
}

.duration-info {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 40px;
  text-shadow: 0 1px 3px rgba(255, 105, 180, 0.3);
  padding: 8px 16px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(5px);
}

.demo-area {
  margin-top: 30px;
}

.cute-box {
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
  border-radius: 25px;
  padding: 30px;
  box-shadow: 0 8px 32px rgba(255, 105, 180, 0.3),
    inset 0 1px 0 rgba(255, 255, 255, 0.4);
  border: 1px solid rgba(255, 255, 255, 0.2);
  animation: boxFloat 3s ease-in-out infinite alternate;

  .box-emoji {
    font-size: 24px;
    margin: 0 10px;
    animation: emojiSpin 3s linear infinite;
  }

  p {
    color: #fff;
    font-size: 16px;
    margin: 15px 0;
    text-shadow: 0 1px 3px rgba(255, 105, 180, 0.5);
  }
}

// 动画定义 - 500毫秒内完成
@keyframes heartFloat {
  0% {
    opacity: 1;
    transform: translateY(0) scale(0) rotate(0deg);
  }
  20% {
    opacity: 1;
    transform: translateY(-15px) scale(1.3) rotate(-8deg);
  }
  40% {
    opacity: 1;
    transform: translateY(-35px) scale(1.1) rotate(5deg);
  }
  70% {
    opacity: 0.8;
    transform: translateY(-60px) scale(0.8) rotate(-3deg);
  }
  100% {
    opacity: 0;
    transform: translateY(-80px) scale(0.3) rotate(12deg);
  }
}

@keyframes titlePulse {
  0% {
    transform: scale(1);
    text-shadow: 0 2px 10px rgba(255, 105, 180, 0.8);
  }
  100% {
    transform: scale(1.05);
    text-shadow: 0 2px 15px rgba(255, 105, 180, 1);
  }
}

@keyframes boxFloat {
  0% {
    transform: translateY(0px);
    box-shadow: 0 8px 32px rgba(255, 105, 180, 0.3),
      inset 0 1px 0 rgba(255, 255, 255, 0.4);
  }
  100% {
    transform: translateY(-10px);
    box-shadow: 0 15px 40px rgba(255, 105, 180, 0.4),
      inset 0 1px 0 rgba(255, 255, 255, 0.4);
  }
}

@keyframes emojiSpin {
  0% {
    transform: rotate(0deg);
  }
  25% {
    transform: rotate(-10deg);
  }
  50% {
    transform: rotate(0deg);
  }
  75% {
    transform: rotate(10deg);
  }
  100% {
    transform: rotate(0deg);
  }
}

// 移动端适配
@media (max-width: 768px) {
  .title {
    font-size: 24px;
    margin-bottom: 12px;
  }

  .subtitle {
    font-size: 16px;
    margin-bottom: 8px;
  }

  .duration-info {
    font-size: 13px;
    margin-bottom: 30px;
    padding: 6px 12px;
  }

  .cute-box {
    padding: 25px 20px;
    margin: 0 10px;

    .box-emoji {
      font-size: 20px;
    }

    p {
      font-size: 14px;
    }
  }

  .heart {
    font-size: 25px;
  }
}

// iPhone 14 Pro Max 特殊适配 (430×932)
@media (max-width: 430px) and (max-height: 932px) {
  .content {
    padding: 15px;
  }

  .title {
    font-size: 22px;
  }

  .subtitle {
    font-size: 15px;
  }

  .duration-info {
    font-size: 12px;
    padding: 5px 10px;
  }

  .cute-box {
    padding: 20px 15px;
  }

  .heart {
    font-size: 22px;
  }
}

// 优化触摸性能
.heart-container {
  // 开启硬件加速
  transform: translateZ(0);
  -webkit-transform: translateZ(0);

  // 优化触摸滚动
  -webkit-overflow-scrolling: touch;

  // 防止触摸时的各种默认行为
  &::-webkit-scrollbar {
    display: none;
  }
}
</style>
