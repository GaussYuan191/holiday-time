<template>
  <div class="cute-clock-container">
    <div class="clock-wrapper">
      <!-- 可爱的装饰元素 -->
      <div class="decoration-stars">
        <div class="star star-1">🌸</div>
        <div class="star star-2">💖</div>
        <div class="star star-3">✨</div>
        <div class="star star-4">🎀</div>
        <div class="star star-5">💕</div>
        <div class="star star-6">🌺</div>
      </div>

      <!-- 主时钟区域 -->
      <div class="clock-main">
        <!-- 可爱的表情 -->
        <div class="clock-face">
          <div class="eyes">
            <div class="eye eye-left">
              <div class="eyeball"></div>
            </div>
            <div class="eye eye-right">
              <div class="eyeball"></div>
            </div>
          </div>
          <div class="mouth">
            <div class="smile"></div>
          </div>
        </div>

        <!-- 日期显示 -->
        <div class="date-section">
          <div class="date-label">
            <span class="label-icon">🌸</span>
            今天是
            <span class="label-icon">🌸</span>
          </div>
          <div class="date-value">
            <div class="date-part year">{{ currentTime.year }}</div>
            <div class="date-separator">年</div>
            <div class="date-part month">{{ currentTime.month }}</div>
            <div class="date-separator">月</div>
            <div class="date-part day">{{ currentTime.day }}</div>
            <div class="date-separator">日</div>
          </div>
          <div class="weekday">{{ currentTime.weekday }}</div>
        </div>

        <!-- 时间显示 -->
        <div class="time-section">
          <div class="time-label">
            <span class="label-icon">⏰</span>
            现在是
            <span class="label-icon">⏰</span>
          </div>
          <div class="time-value">
            <div class="time-part-container">
              <div class="time-part hour">{{ currentTime.hours }}</div>
              <div class="time-unit">时</div>
            </div>
            <div class="time-separator blink">:</div>
            <div class="time-part-container">
              <div class="time-part minute">{{ currentTime.minutes }}</div>
              <div class="time-unit">分</div>
            </div>
            <div class="time-separator blink">:</div>
            <div class="time-part-container">
              <div class="time-part second">{{ currentTime.seconds }}</div>
              <div class="time-unit">秒</div>
            </div>
          </div>
        </div>

        <!-- 问候语 -->
        <div class="greeting">
          <div class="greeting-content">
            <span class="greeting-icon">{{ greetingData.icon }}</span>
            <span class="greeting-text">{{ greetingData.text }}</span>
          </div>
          <div class="greeting-subtitle">{{ greetingData.subtitle }}</div>
        </div>
      </div>

      <!-- 底部装饰 -->
      <div class="bottom-decoration">
        <div class="hearts">
          <span class="heart heart-1">💗</span>
          <span class="heart heart-2">💖</span>
          <span class="heart heart-3">💕</span>
          <span class="heart heart-4">💓</span>
          <span class="heart heart-5">💝</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from "vue";

interface TimeData {
  year: string;
  month: string;
  day: string;
  hours: string;
  minutes: string;
  seconds: string;
  weekday: string;
}

interface GreetingData {
  icon: string;
  text: string;
  subtitle: string;
}

const now = ref(new Date());
let timer: number | null = null;

const updateTime = () => {
  now.value = new Date();
};

const currentTime = computed<TimeData>(() => {
  const date = now.value;
  const weekdays = [
    "星期日",
    "星期一",
    "星期二",
    "星期三",
    "星期四",
    "星期五",
    "星期六",
  ];

  return {
    year: String(date.getFullYear()),
    month: String(date.getMonth() + 1).padStart(2, "0"),
    day: String(date.getDate()).padStart(2, "0"),
    hours: String(date.getHours()).padStart(2, "0"),
    minutes: String(date.getMinutes()).padStart(2, "0"),
    seconds: String(date.getSeconds()).padStart(2, "0"),
    weekday: weekdays[date.getDay()],
  };
});

const greetingData = computed<GreetingData>(() => {
  const hour = now.value.getHours();

  if (hour >= 5 && hour < 9) {
    return {
      icon: "🌅",
      text: "早安，美好的一天开始啦！",
      subtitle: "愿你今天充满活力～",
    };
  } else if (hour >= 9 && hour < 12) {
    return {
      icon: "☀️",
      text: "上午好，加油工作哦！",
      subtitle: "记得喝水和休息～",
    };
  } else if (hour >= 12 && hour < 14) {
    return {
      icon: "🍽️",
      text: "午餐时间到啦～",
      subtitle: "好好吃饭才有力气！",
    };
  } else if (hour >= 14 && hour < 18) {
    return {
      icon: "🌤️",
      text: "下午好，继续加油！",
      subtitle: "距离下班又近了一步～",
    };
  } else if (hour >= 18 && hour < 22) {
    return {
      icon: "🌆",
      text: "晚上好，辛苦啦！",
      subtitle: "享受美好的夜晚时光～",
    };
  } else {
    return {
      icon: "🌙",
      text: "夜深了，该休息啦！",
      subtitle: "早点睡觉，明天更美好～",
    };
  }
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
  box-sizing: border-box;
  transform: scale(0.8);
}

.clock-wrapper {
  position: relative;
  background: linear-gradient(145deg, #ffffff, #ffe0e6);
  border-radius: 40px;
  padding: 40px 30px;
  box-shadow: 20px 20px 60px #ffb3ba, -20px -20px 60px #ffffff,
    inset 5px 5px 10px rgba(255, 255, 255, 0.8),
    inset -5px -5px 10px rgba(255, 182, 193, 0.2);
  max-width: 450px;
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
      rgba(255, 182, 193, 0.1),
      transparent,
      rgba(255, 192, 203, 0.15),
      transparent,
      rgba(255, 105, 180, 0.1),
      transparent
    );
    animation: rotate 15s linear infinite;
    z-index: -1;
  }

  &::after {
    content: "";
    position: absolute;
    top: 10px;
    left: 10px;
    right: 10px;
    bottom: 10px;
    border-radius: 30px;
    background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.1));
    pointer-events: none;
    z-index: 1;
  }
}

.decoration-stars {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 2;

  .star {
    position: absolute;
    font-size: 18px;
    animation: twinkle 3s ease-in-out infinite;

    &.star-1 {
      top: 8%;
      left: 12%;
      animation-delay: 0s;
    }
    &.star-2 {
      top: 15%;
      right: 15%;
      animation-delay: 0.5s;
    }
    &.star-3 {
      top: 45%;
      left: 8%;
      animation-delay: 1s;
    }
    &.star-4 {
      top: 44%;
      right: 10%;
      animation-delay: 1.5s;
    }
    &.star-5 {
      bottom: 30%;
      left: 12%;
      animation-delay: 2s;
    }
    &.star-6 {
      bottom: 15%;
      right: 18%;
      animation-delay: 2.5s;
    }
  }
}

.clock-main {
  position: relative;
  z-index: 3;
}

.greeting {
  .greeting-icon {
    font-size: 24px;
    margin-right: 8px;
    display: inline-block;
    animation: bounce 2s ease-in-out infinite;
  }
}

.clock-face {
  margin-bottom: 35px;

  .eyes {
    display: flex;
    justify-content: center;
    gap: 25px;
    margin-bottom: 15px;

    .eye {
      width: 35px;
      height: 35px;
      background: #fff;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: inset 2px 2px 5px rgba(255, 182, 193, 0.3),
        2px 2px 8px rgba(255, 182, 193, 0.2);
      animation: blink 4s infinite;

      .eyeball {
        width: 15px;
        height: 15px;
        background: #ff69b4;
        border-radius: 50%;
        animation: look-around 6s ease-in-out infinite;
      }
    }
  }

  .mouth {
    display: flex;
    justify-content: center;

    .smile {
      width: 30px;
      height: 15px;
      border: 3px solid #ff69b4;
      border-top: none;
      border-radius: 0 0 30px 30px;
      animation: smile 3s ease-in-out infinite alternate;
    }
  }
}

.date-section {
  margin-bottom: 30px;

  .date-label {
    font-size: 16px;
    color: #ff69b4;
    margin-bottom: 12px;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;

    .label-icon {
      animation: bounce 2s ease-in-out infinite;
    }
  }

  .date-value {
    display: flex;
    justify-content: center;
    align-items: baseline;
    gap: 8px;
    margin-bottom: 10px;

    .date-part {
      background: linear-gradient(145deg, #ff69b4, #ff1493);
      color: white;
      padding: 12px 16px;
      border-radius: 20px;
      font-size: 20px;
      font-weight: bold;
      font-family: "Arial", sans-serif;
      box-shadow: 5px 5px 15px rgba(255, 105, 180, 0.3),
        -2px -2px 8px rgba(255, 255, 255, 0.8),
        inset 1px 1px 3px rgba(255, 255, 255, 0.5);
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;

      &::before {
        content: "";
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(
          90deg,
          transparent,
          rgba(255, 255, 255, 0.3),
          transparent
        );
        animation: shine 3s ease-in-out infinite;
      }

      &:hover {
        transform: translateY(-3px) scale(1.05);
        box-shadow: 7px 7px 20px rgba(255, 105, 180, 0.4),
          -3px -3px 10px rgba(255, 255, 255, 0.9);
      }
    }

    .date-separator {
      font-size: 16px;
      color: #ff69b4;
      font-weight: 600;
      display: flex;
      align-items: center;
    }
  }

  .weekday {
    font-size: 18px;
    color: #ff1493;
    font-weight: 600;
    background: linear-gradient(45deg, #ffc0cb, #ffb6c1);
    padding: 8px 20px;
    border-radius: 25px;
    display: inline-block;
    box-shadow: 3px 3px 10px rgba(255, 182, 193, 0.4),
      -2px -2px 6px rgba(255, 255, 255, 0.8);
  }
}

.time-section {
  margin-bottom: 30px;

  .time-label {
    font-size: 16px;
    color: #ff69b4;
    margin-bottom: 15px;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;

    .label-icon {
      animation: swing 2s ease-in-out;
    }
  }
  .time-value {
    display: flex;
    justify-content: center;
    .time-part-container,
    .time-part-container,
    .time-part-container {
      display: flex;
    }
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

@keyframes heartbeat {
  0%,
  100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.2);
  }
}
</style>
