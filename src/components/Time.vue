<template>
  <div class="cute-clock-container">
    <div class="clock-wrapper">
      <!-- 可爱的装饰元素 -->
      <div class="decoration-stars">
        <div class="star star-1">⭐</div>
        <div class="star star-2">✨</div>
        <div class="star star-3">🌟</div>
        <div class="star star-4">💫</div>
      </div>

      <!-- 主时钟区域 -->
      <div class="clock-main">
        <!-- 可爱的表情 -->
        <div class="clock-face">
          <div class="eyes">
            <div class="eye eye-left">👁️</div>
            <div class="eye eye-right">👁️</div>
          </div>
          <div class="mouth">😊</div>
        </div>

        <!-- 日期显示 -->
        <div class="date-section">
          <div class="date-label">📅 今天是</div>
          <div class="date-value">{{ formattedDate }}</div>
        </div>

        <!-- 时间显示  -->
        <div class="time-section">
          <div class="time-label">⏰ 现在是</div>
          <div class="time-value">
            <span class="time-part hour">{{ currentTime.hours }}</span>
            <span class="time-separator blink">:</span>
            <span class="time-part minute">{{ currentTime.minutes }}</span>
            <span class="time-separator blink">:</span>
            <span class="time-part second">{{ currentTime.seconds }}</span>
          </div>
        </div>

        <!-- 问候语 -->
        <div class="greeting">
          <span class="greeting-icon">{{ greetingIcon }}</span>
          <span class="greeting-text">{{ greetingText }}</span>
        </div>
      </div>

      <!-- 底部装饰 -->
      <div class="bottom-decoration">
        <div class="hearts">
          <span class="heart heart-1">💖</span>
          <span class="heart heart-2">💕</span>
          <span class="heart heart-3">💗</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from "vue";

interface TimeData {
  hours: string;
  minutes: string;
  seconds: string;
}

const now = ref(new Date());
let timer: number | null = null;

const updateTime = () => {
  now.value = new Date();
};

const currentTime = computed<TimeData>(() => {
  const date = now.value;
  return {
    hours: String(date.getHours()).padStart(2, "0"),
    minutes: String(date.getMinutes()).padStart(2, "0"),
    seconds: String(date.getSeconds()).padStart(2, "0"),
  };
});

const formattedDate = computed(() => {
  const date = now.value;
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  const weekdays = [
    "星期日",
    "星期一",
    "星期二",
    "星期三",
    "星期四",
    "星期五",
    "星期六",
  ];
  const weekday = weekdays[date.getDay()];
  return `${year}-${month}-${day} ${weekday}`;
});

const greetingIcon = computed(() => {
  const hour = now.value.getHours();
  if (hour >= 6 && hour < 12) return "🌅";
  if (hour >= 12 && hour < 18) return "☀️";
  if (hour >= 18 && hour < 22) return "🌆";
  return "🌙";
});

const greetingText = computed(() => {
  const hour = now.value.getHours();
  if (hour >= 6 && hour < 12) return "早上好！";
  if (hour >= 12 && hour < 14) return "中午好！";
  if (hour >= 14 && hour < 18) return "下午好！";
  if (hour >= 18 && hour < 22) return "晚上好！";
  return "夜深了，注意休息！";
});

onMounted(() => {
  updateTime();
  timer = setInterval(updateTime, 1000);
});

onUnmounted(() => {
  if (timer) {
    clearInterval(timer);
    timer = null;
  }
});
</script>

<style lang="less" scoped>
.cute-clock-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  padding: 20px;
  box-sizing: border-box;
}

.clock-wrapper {
  position: relative;
  background: linear-gradient(145deg, #ffffff, #f0f0f0);
  border-radius: 30px;
  padding: 40px 30px;
  box-shadow: 20px 20px 60px #d1d1d1, -20px -20px 60px #ffffff;
  max-width: 400px;
  width: 100%;
  text-align: center;
  overflow: hidden;

  &::before {
    content: "";
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: conic-gradient(
      from 0deg,
      transparent,
      rgba(255, 192, 203, 0.1),
      transparent,
      rgba(173, 216, 230, 0.1),
      transparent
    );
    animation: rotate 10s linear infinite;
    z-index: -1;
  }
}

.decoration-stars {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;

  .star {
    position: absolute;
    font-size: 16px;
    animation: twinkle 2s ease-in-out infinite alternate;

    &.star-1 {
      top: 10%;
      left: 10%;
      animation-delay: 0s;
    }

    &.star-2 {
      top: 20%;
      right: 15%;
      animation-delay: 0.5s;
    }

    &.star-3 {
      bottom: 25%;
      left: 15%;
      animation-delay: 1s;
    }

    &.star-4 {
      bottom: 15%;
      right: 10%;
      animation-delay: 1.5s;
    }
  }
}

.clock-main {
  position: relative;
  z-index: 1;
}

.clock-face {
  margin-bottom: 30px;

  .eyes {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-bottom: 10px;

    .eye {
      font-size: 24px;
      animation: blink 3s infinite;
    }
  }

  .mouth {
    font-size: 28px;
    animation: smile 2s ease-in-out infinite alternate;
  }
}

.date-section {
  margin-bottom: 25px;

  .date-label {
    font-size: 16px;
    color: #666;
    margin-bottom: 8px;
    font-weight: 500;
  }

  .date-value {
    font-size: 18px;
    color: #333;
    font-weight: 600;
    background: linear-gradient(45deg, #ff6b6b, #ffa726);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }
}

.time-section {
  margin-bottom: 25px;

  .time-label {
    font-size: 16px;
    color: #666;
    margin-bottom: 12px;
    font-weight: 500;
  }

  .time-value {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 5px;

    .time-part {
      background: linear-gradient(145deg, #667eea, #764ba2);
      color: white;
      padding: 10px 15px;
      border-radius: 15px;
      font-size: 24px;
      font-weight: bold;
      font-family: "Courier New", monospace;
      box-shadow: 5px 5px 15px rgba(0, 0, 0, 0.1),
        -5px -5px 15px rgba(255, 255, 255, 0.1);
      transition: all 0.3s ease;

      &:hover {
        transform: translateY(-2px);
        box-shadow: 7px 7px 20px rgba(0, 0, 0, 0.15),
          -7px -7px 20px rgba(255, 255, 255, 0.15);
      }
    }

    .time-separator {
      font-size: 24px;
      font-weight: bold;
      color: #667eea;
      margin: 0 5px;

      &.blink {
        animation: blink-separator 1s infinite;
      }
    }
  }
}

.greeting {
  margin-bottom: 20px;

  .greeting-icon {
    font-size: 24px;
    margin-right: 8px;
    display: inline-block;
    animation: bounce 2s ease-in-out infinite;
  }

  .greeting-text {
    font-size: 18px;
    color: #555;
    font-weight: 600;
  }
}

.bottom-decoration {
  .hearts {
    display: flex;
    justify-content: center;
    gap: 15px;

    .heart {
      font-size: 20px;
      animation: heartbeat 1.5s ease-in-out infinite;

      &.heart-1 {
        animation-delay: 0s;
      }

      &.heart-2 {
        animation-delay: 0.3s;
      }

      &.heart-3 {
        animation-delay: 0.6s;
      }
    }
  }
}

// 动画定义
@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

@keyframes twinkle {
  0% {
    opacity: 0.3;
    transform: scale(0.8);
  }
  100% {
    opacity: 1;
    transform: scale(1.2);
  }
}

@keyframes blink {
  0%,
  90%,
  100% {
    transform: scaleY(1);
  }
  95% {
    transform: scaleY(0.1);
  }
}

@keyframes smile {
  0% {
    transform: scale(1);
  }
  100% {
    transform: scale(1.1);
  }
}

@keyframes blink-separator {
  0%,
  50% {
    opacity: 1;
  }
  51%,
  100% {
    opacity: 0.3;
  }
}

@keyframes bounce {
  0%,
  20%,
  50%,
  80%,
  100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(-10px);
  }
  60% {
    transform: translateY(-5px);
  }
}

@keyframes heartbeat {
  0%,
  100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.2);
  }
}

// 移动端适配
@media (max-width: 768px) {
  .cute-clock-container {
    min-height: auto;
    padding: 15px;
  }

  .clock-wrapper {
    padding: 30px 20px;
    border-radius: 25px;
    max-width: 350px;
  }

  .clock-face {
    margin-bottom: 25px;

    .eyes {
      gap: 15px;

      .eye {
        font-size: 20px;
      }
    }

    .mouth {
      font-size: 24px;
    }
  }

  .date-section {
    margin-bottom: 20px;

    .date-label {
      font-size: 14px;
    }

    .date-value {
      font-size: 16px;
    }
  }

  .time-section {
    margin-bottom: 20px;

    .time-label {
      font-size: 14px;
    }

    .time-value {
      .time-part {
        padding: 8px 12px;
        font-size: 20px;
        border-radius: 12px;
      }

      .time-separator {
        font-size: 20px;
        margin: 0 3px;
      }
    }
  }

  .greeting {
    .greeting-icon {
      font-size: 20px;
    }

    .greeting-text {
      font-size: 16px;
    }
  }

  .decoration-stars {
    .star {
      font-size: 14px;
    }
  }

  .bottom-decoration {
    .hearts {
      gap: 12px;

      .heart {
        font-size: 18px;
      }
    }
  }
}

@media (max-width: 430px) {
  .clock-wrapper {
    padding: 25px 15px;
    border-radius: 20px;
    max-width: 260px;
  }

  .time-section {
    .time-value {
      flex-wrap: wrap;
      gap: 8px;

      .time-part {
        padding: 6px 10px;
        font-size: 18px;
      }

      .time-separator {
        font-size: 18px;
      }
    }
  }

  .date-section {
    .date-value {
      font-size: 14px;
      line-height: 1.4;
    }
  }
}
</style>
