<script setup lang="ts">
import { ref, onMounted, onUnmounted } from "vue";

const now = ref(new Date());

const updateTime = () => {
  now.value = new Date();
};

let timer: number | undefined;

onMounted(() => {
  timer = setInterval(updateTime, 1000);
});

onUnmounted(() => {
  if (timer) {
    clearInterval(timer);
  }
});

// 自定义日期格式化函数
const formatDate = (date: Date) => {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0"); // 月份从0开始，所以需要+1
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};
</script>

<template>
  <div class="now-time">
    <div class="text">当前时间</div>
    <div class="time-display">
      {{ formatDate(now) }} {{ now.toLocaleTimeString() }}
    </div>
  </div>
</template>

<style scoped>
.time-display {
  font-family: "Arial", sans-serif;
  font-size: 1.5em; /* 调整字体大小以适应更多的文本 */
  color: #333;
  text-align: center;
  padding: 1em;
  background-color: #f0f0f0;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  margin: 1em;
  display: flex;
  flex-direction: column; /* 将时间和日期堆叠显示 */
}

@media (max-width: 600px) {
  .time-display {
    font-size: 1.2em; /* 在手机端进一步减小字体大小 */
  }
}
</style>
