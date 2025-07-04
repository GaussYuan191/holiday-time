<template>
  <div class="event-manager">
    <!-- 顶部时间显示 -->
    <NewClock />
    <!-- 装饰元素 -->
    <div class="decoration decoration-1"></div>
    <div class="decoration decoration-2"></div>
    <div class="decoration decoration-3"></div>
    <div class="floating floating-1">🌸</div>
    <div class="floating floating-2">🌼</div>

    <!-- 事件列表 -->
    <div v-if="events.length > 0" class="event-list">
      <div v-for="(event, index) in events" :key="event.id" class="event-card">
        <!-- 装饰角 -->
        <div class="cute-corner top-left"></div>
        <div class="cute-corner top-right"></div>
        <div class="cute-corner bottom-left"></div>
        <div class="cute-corner bottom-right"></div>

        <div class="event-header">
          <div class="event-name">{{ event.name }}</div>
          <div class="event-actions">
            <!-- <van-button
              round
              icon="edit"
              size="small"
              color="linear-gradient(to right, #ff9ecb, #ff6b9c)"
              @click="editEvent(index)"
            />
            <van-button
              round
              icon="delete"
              size="small"
              color="linear-gradient(to right, #ffb3c7, #ff8da3)"
              @click="deleteEvent(index)"
            /> -->
          </div>
        </div>

        <div class="event-time">
          <div>
            <strong>开始:</strong>
            {{ formatDateTime(event.startDate, event.startTime) }}
          </div>
          <div>
            <strong>结束:</strong>
            {{ formatDateTime(event.endDate, event.endTime) }}
          </div>
        </div>

        <div class="event-status" :class="getStatusClass(event)">
          <span v-if="event.status === 'before'" class="status-before">
            剩余时间: {{ event.remainingTime }}
          </span>
          <span v-else-if="event.status === 'during'" class="status-during">
            🎉 正在享受{{ event.name }}
          </span>
        </div>
      </div>
    </div>

    <!-- <div v-else class="empty-state">
      <div class="empty-icon">📅</div>
      <p class="empty-text">还没有添加任何事件~</p>
      <p>点击右下角按钮添加第一个事件吧！</p>
    </div> -->

    <!-- 添加按钮 -->
    <!-- <van-button
      class="add-btn"
      round
      icon="plus"
      color="linear-gradient(to right, #ff9ecb, #ff6b9c)"
      @click="openAddDialog"
    /> -->

    <!-- 添加/编辑事件弹窗 -->
    <van-popup
      v-model:show="showAddDialog"
      round
      position="bottom"
      :style="{ height: '75%' }"
    >
      <div class="dialog-content">
        <h2 class="dialog-title">
          {{ editingIndex === null ? "添加新事件" : "编辑事件" }}
        </h2>

        <div class="form-item">
          <label class="form-label">事件名称</label>
          <van-field
            v-model="newEvent.name"
            placeholder="输入事件名称"
            :style="{ background: '#fff0f7', borderRadius: '12px' }"
          />
        </div>

        <div class="form-item">
          <label class="form-label">开始日期</label>
          <div class="picker-btn" @click="showDatePicker('start')">
            选择开始日期
            <div class="selected-time" v-if="newEvent.startDate.length">
              {{ newEvent.startDate.join("-") }}
            </div>
          </div>
        </div>

        <div class="form-item">
          <label class="form-label">开始时间</label>
          <div class="picker-btn" @click="showTimePicker('start')">
            选择开始时间
            <div class="selected-time" v-if="newEvent.startTime.length">
              {{ newEvent.startTime.join(":") }}
            </div>
          </div>
        </div>

        <div class="form-item">
          <label class="form-label">结束日期</label>
          <div class="picker-btn" @click="showDatePicker('end')">
            选择结束日期
            <div class="selected-time" v-if="newEvent.endDate.length">
              {{ newEvent.endDate.join("-") }}
            </div>
          </div>
        </div>

        <div class="form-item">
          <label class="form-label">结束时间</label>
          <div class="picker-btn" @click="showTimePicker('end')">
            选择结束时间
            <div class="selected-time" v-if="newEvent.endTime.length">
              {{ newEvent.endTime.join(":") }}
            </div>
          </div>
        </div>

        <van-button
          class="submit-btn"
          block
          :color="
            editingIndex === null
              ? 'linear-gradient(to right, #ff9ecb, #ff6b9c)'
              : 'linear-gradient(to right, #ffb3d9, #ff8da3)'
          "
          @click="saveEvent"
        >
          {{ editingIndex === null ? "添加事件" : "保存修改" }}
        </van-button>
      </div>
    </van-popup>

    <!-- 日期选择器 -->
    <van-popup v-model:show="showDatePickerVisible" round position="bottom">
      <van-date-picker
        v-model="currentDate"
        title="选择日期"
        :columns-type="['year', 'month', 'day']"
        @confirm="onDateConfirm"
        @cancel="showDatePickerVisible = false"
      />
    </van-popup>

    <!-- 时间选择器 -->
    <van-popup v-model:show="showTimePickerVisible" round position="bottom">
      <van-time-picker
        v-model="currentTime"
        title="选择时间"
        :columns-type="['hour', 'minute', 'second']"
        @confirm="onTimeConfirm"
        @cancel="showTimePickerVisible = false"
      />
    </van-popup>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, onBeforeUnmount } from "vue";
import { Popup, DatePicker, TimePicker, Field, Button, showToast } from "vant";
import dayjs from "dayjs";
import relativeTime from "dayjs/plugin/relativeTime";
import Time from "./Time.vue";
import NewClock from "./NewClock.vue";

// 初始化dayjs插件
dayjs.extend(relativeTime);

interface EventItem {
  id: number;
  name: string;
  startDate: string[];
  startTime: string[];
  endDate: string[];
  endTime: string[];
  remainingTime: String; // 剩余时间
  status: "before" | "during";
}

export default defineComponent({
  name: "EventManager",
  components: {
    [Popup.name]: Popup,
    [DatePicker.name]: DatePicker,
    [TimePicker.name]: TimePicker,
    [Field.name]: Field,
    [Button.name]: Button,
    Time,
    NewClock,
  },
  setup() {
    // 事件数据
    const events = ref<EventItem[]>([]);
    const showAddDialog = ref(false);
    const editingIndex = ref<number | null>(null);

    // 当前时间
    const currentDate = ref("");
    const currentTime = ref("");

    // 新事件数据
    const newEvent = ref<EventItem>({
      id: 0,
      name: "",
      startDate: [],
      startTime: [],
      endDate: [],
      endTime: [],
      remainingTime: "",
      status: "before",
    });

    // 日期时间选择器
    const showDatePickerVisible = ref(false);
    const showTimePickerVisible = ref(false);
    const currentDatePicker = ref(["2025", "01", "01"]);
    const currentTimePicker = ref(["00", "00", "00"]);
    const currentPickerType = ref(""); // 'start' or 'end'

    // 初始化默认事件
    const defaultEvent: EventItem = {
      id: 1,
      name: "慧慧的暑假",
      startDate: ["2025", "07", "11"],
      startTime: ["17", "30", "00"],
      endDate: ["2025", "08", "30"],
      endTime: ["23", "59", "59"],
      remainingTime: "",
      status: "before",
    };

    // 更新当前时间
    const updateCurrentTime = () => {
      const now = dayjs();
      currentDate.value = now.format("YYYY年MM月DD日");
      currentTime.value = now.format("HH:mm:ss");
    };

    // 从本地存储加载事件
    const loadEvents = () => {
      const savedEvents = localStorage.getItem("events");
      if (savedEvents) {
        events.value = JSON.parse(savedEvents);
      } else {
        events.value = [defaultEvent];
        saveEvents();
      }

      // 过滤掉已结束的事件
      events.value = events.value.filter((event) => {
        return dayjs().isBefore(getDateTime(event.endDate, event.endTime));
      });
      saveEvents();
    };

    // 保存事件到本地存储
    const saveEvents = () => {
      localStorage.setItem("events", JSON.stringify(events.value));
    };

    // 组合日期和时间
    const getDateTime = (dateArr: string[], timeArr: string[]) => {
      if (dateArr.length !== 3 || timeArr.length !== 3) return null;
      return dayjs(`${dateArr.join("-")} ${timeArr.join(":")}`);
    };

    // 格式化日期时间显示
    const formatDateTime = (dateArr: string[], timeArr: string[]) => {
      if (dateArr.length !== 3 || timeArr.length !== 3) return "未设置";
      return `${dateArr.join("/")} ${timeArr.join(":")}`;
    };
    const calculateRemainingTime = (
      startDate: Date,
      status: string
    ): string => {
      if (status !== "before") return "";
      const now = new Date();
      const diff = startDate.getTime() - now.getTime();
      if (diff <= 0) {
        return "已开始";
      }
      const days = Math.floor(diff / (1000 * 60 * 60 * 24));
      const hours = Math.floor(
        (diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)
      );
      const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
      const second = Math.floor((diff % (1000 * 60)) / 1000);
      return `${days}天 ${hours}小时 ${minutes}分钟 ${second}秒`;
    };
    // 打开添加事件对话框
    const openAddDialog = () => {
      resetForm();
      editingIndex.value = null;
      showAddDialog.value = true;
    };

    // 显示日期选择器
    const showDatePicker = (type: string) => {
      currentPickerType.value = type;
      const dateField = `${type}Date`;

      if (newEvent.value[dateField].length === 3) {
        currentDatePicker.value = [...newEvent.value[dateField]];
      } else {
        currentDatePicker.value = [
          dayjs().format("YYYY"),
          dayjs().format("MM"),
          dayjs().format("DD"),
        ];
      }

      showDatePickerVisible.value = true;
    };

    // 显示时间选择器
    const showTimePicker = (type: string) => {
      currentPickerType.value = type;
      const timeField = `${type}Time`;

      if (newEvent.value[timeField].length === 3) {
        currentTimePicker.value = [...newEvent.value[timeField]];
      } else {
        currentTimePicker.value = [
          dayjs().format("HH"),
          dayjs().format("mm"),
          dayjs().format("ss"),
        ];
      }

      showTimePickerVisible.value = true;
    };

    // 日期选择确认
    const onDateConfirm = ({
      selectedValues,
    }: {
      selectedValues: string[];
    }) => {
      const type = currentPickerType.value;
      (newEvent.value as any)[`${type}Date`] = selectedValues;
      showDatePickerVisible.value = false;
    };

    // 时间选择确认
    const onTimeConfirm = ({
      selectedValues,
    }: {
      selectedValues: string[];
    }) => {
      const type = currentPickerType.value;
      (newEvent.value as any)[`${type}Time`] = selectedValues;
      showTimePickerVisible.value = false;
    };

    // 添加/保存事件
    const saveEvent = () => {
      if (!newEvent.value.name.trim()) {
        showToast("请输入事件名称");
        return;
      }

      if (
        newEvent.value.startDate.length !== 3 ||
        newEvent.value.startTime.length !== 3
      ) {
        showToast("请选择开始日期和时间");
        return;
      }

      if (
        newEvent.value.endDate.length !== 3 ||
        newEvent.value.endTime.length !== 3
      ) {
        showToast("请选择结束日期和时间");
        return;
      }

      const start = getDateTime(
        newEvent.value.startDate,
        newEvent.value.startTime
      );
      const end = getDateTime(newEvent.value.endDate, newEvent.value.endTime);

      if (!start || !end) {
        showToast("日期时间格式错误");
        return;
      }

      if (start.isAfter(end)) {
        showToast("开始时间不能晚于结束时间");
        return;
      }

      if (editingIndex.value === null) {
        // 添加新事件
        newEvent.value.id = Date.now();
        events.value.unshift({ ...newEvent.value });
      } else {
        // 更新现有事件
        events.value[editingIndex.value] = { ...newEvent.value };
      }

      saveEvents();
      resetForm();
      showAddDialog.value = false;
      showToast(editingIndex.value === null ? "事件添加成功" : "事件更新成功");
    };

    // 编辑事件
    const editEvent = (index: number) => {
      editingIndex.value = index;
      newEvent.value = { ...events.value[index] };
      showAddDialog.value = true;
    };

    // 删除事件
    const deleteEvent = (index: number) => {
      events.value.splice(index, 1);
      saveEvents();
      showToast("事件已删除");
    };

    // 重置表单
    const resetForm = () => {
      newEvent.value = {
        id: 0,
        name: "",
        startDate: [],
        startTime: [],
        endDate: [],
        endTime: [],
        remainingTime: "",
        status: "before",
      };
    };

    // 获取事件状态类
    const getStatusClass = (event: EventItem) => {
      const now = dayjs();
      const start = getDateTime(event.startDate, event.startTime);
      const end = getDateTime(event.endDate, event.endTime);
      if (!start || !end) return "";
      if (now.isBefore(start)) {
        return "countdown";
      } else if (now.isAfter(start) && now.isBefore(end)) {
        return "enjoy";
      }
      return "";
    };

    // 更新文本中剩余时间
    const updateEventsRemainingTime = () => {
      events.value.forEach((event) => {
        const now = dayjs();
        const start = getDateTime(event.startDate, event.startTime) || dayjs();
        const end = getDateTime(event.endDate, event.endTime);
        if (!start || !end) return "";
        if (now.isBefore(start)) {
          event.status = "before";
          event.remainingTime = calculateRemainingTime(
            start.toDate(),
            "before"
          );
        } else if (now.isAfter(start) && now.isBefore(end)) {
          event.status = "during";
        }
        return "";
      });
    };
    // 获取事件状态文本
    const getStatusText = (event: EventItem) => {
      const now = dayjs();
      const start = getDateTime(event.startDate, event.startTime);
      const end = getDateTime(event.endDate, event.endTime);

      if (!start || !end) return "";
      console.log("start", start, event, start.fromNow(true));
      if (now.isBefore(start)) {
        return `距离开始还有 ${calculateRemainingTime(
          start.toDate(),
          "before"
        )}`;
      } else if (now.isAfter(start) && now.isBefore(end)) {
        return `享受${event.name}中...`;
      }
      return "";
    };

    // 组件挂载时加载事件
    onMounted(() => {
      loadEvents();
      updateCurrentTime();
      // 每秒更新一次时间
      const currentTimer = setInterval(updateCurrentTime, 1000);
      const calcTimer = setInterval(updateEventsRemainingTime, 1000);
      onBeforeUnmount(() => {
        clearInterval(currentTimer);
        clearInterval(calcTimer);
      });
    });

    return {
      events,
      showAddDialog,
      editingIndex,
      newEvent,
      showDatePickerVisible,
      showTimePickerVisible,
      currentDatePicker,
      currentTimePicker,
      currentDate,
      currentTime,
      openAddDialog,
      showDatePicker,
      showTimePicker,
      onDateConfirm,
      onTimeConfirm,
      saveEvent,
      editEvent,
      deleteEvent,
      formatDateTime,
      getStatusClass,
      getStatusText,
    };
  },
});
</script>

<style lang="less" scoped>
.event-manager {
  position: relative;
  background: linear-gradient(135deg, #fff0f7 0%, #ffe6f2 100%);
  font-family: "Comic Sans MS", "Marker Felt", "Arial Rounded MT Bold",
    sans-serif;
  color: #ff6b9c;
  overflow-x: hidden;
  height: 100vh;
  padding: 0 20px;

  .time-display {
    text-align: center;
    margin-bottom: 25px;
    padding: 15px;
    background: rgba(255, 255, 255, 0.7);
    border-radius: 20px;
    box-shadow: 0 5px 15px rgba(255, 107, 156, 0.15);
    position: relative;
    z-index: 2;

    .current-date {
      font-size: 1.4rem;
      font-weight: bold;
      color: #ff6b9c;
      margin-bottom: 8px;
    }

    .current-time {
      font-size: 2.2rem;
      font-weight: bold;
      background: linear-gradient(to right, #ff6b9c, #ff9ecb);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      letter-spacing: 2px;
    }
  }

  .event-list {
    max-width: 600px;
    margin: 0 auto;
    position: relative;
    z-index: 2;
  }

  .event-card {
    background: rgb(255 255 255 / 0%);
    border-radius: 20px;
    padding: 18px;
    margin-bottom: 20px;
    box-shadow: 0 8px 20px rgba(255, 107, 156, 0.15);
    border: 2px solid #ffd1e0;
    position: relative;
    overflow: hidden;
    transition: all 0.3s ease;

    &:hover {
      transform: translateY(-5px);
      box-shadow: 0 12px 25px rgba(255, 107, 156, 0.2);
    }

    .event-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;
    }

    .event-name {
      font-size: 1.4rem;
      font-weight: bold;
      color: #ff6b9c;
      max-width: 70%;
    }

    .event-actions {
      display: flex;
      gap: 8px;
    }

    .event-time {
      margin: 8px 0;
      font-size: 0.95rem;
      color: #e05294;
      display: flex;
      flex-direction: column;
      gap: 5px;
    }

    .event-status {
      margin-top: 12px;
      padding: 10px;
      border-radius: 12px;
      font-weight: bold;
      text-align: center;
      font-size: 1.1rem;
    }

    .countdown {
      // background: linear-gradient(to right, #ffe6f2, #ffd1e0);
      color: #e05294;
    }

    .enjoy {
      background: linear-gradient(to right, #ffd1e0, #ffb3d9);
      color: #d6408f;
    }
  }

  .empty-state {
    text-align: center;
    padding: 60px 20px;
    color: #ff8da3;
    position: relative;
    z-index: 2;

    .empty-icon {
      font-size: 4rem;
      margin-bottom: 20px;
      color: #ffd1e0;
    }

    .empty-text {
      font-size: 1.2rem;
      margin-bottom: 10px;
    }
  }

  .add-btn {
    position: fixed;
    bottom: 30px;
    right: 30px;
    width: 60px;
    height: 60px;
    border-radius: 50%;
    font-size: 1.5rem;
    box-shadow: 0 5px 15px rgba(255, 107, 156, 0.4);
    z-index: 100;
    transition: all 0.3s ease;

    &:active {
      transform: scale(0.95);
    }
  }

  .dialog-content {
    padding: 20px;

    .dialog-title {
      text-align: center;
      margin-bottom: 20px;
      color: #ff6b9c;
      font-size: 1.6rem;
    }

    .form-item {
      margin-bottom: 20px;
    }

    .form-label {
      display: block;
      margin-bottom: 8px;
      font-weight: bold;
      color: #e05294;
      font-size: 1.1rem;
    }

    .picker-btn {
      background: #fff0f7;
      border: 2px dashed #ff9ecb;
      border-radius: 12px;
      padding: 12px;
      text-align: center;
      color: #ff6b9c;
      font-weight: bold;
      cursor: pointer;
      transition: all 0.2s ease;

      &:active {
        background: #ffe6f2;
        border-style: solid;
      }
    }

    .selected-time {
      margin-top: 5px;
      font-size: 0.9rem;
      color: #ff8da3;
    }

    .submit-btn {
      margin-top: 20px;
      border-radius: 12px;
      font-size: 1.1rem;
      font-weight: bold;
      height: 50px;
      box-shadow: 0 4px 10px rgba(255, 107, 156, 0.3);
      border: none;
    }
  }

  // 装饰元素
  .decoration {
    position: absolute;
    z-index: 1;
    opacity: 0.3;
    border-radius: 50%;
    animation: float 6s ease-in-out infinite;
  }

  .decoration-1 {
    top: 10%;
    left: 5%;
    width: 50px;
    height: 50px;
    background: #ff9ecb;
    animation-duration: 6s;
  }

  .decoration-2 {
    top: 25%;
    right: 7%;
    width: 40px;
    height: 40px;
    background: #ffd1e0;
    animation-duration: 7s;
  }

  .decoration-3 {
    bottom: 20%;
    left: 10%;
    width: 30px;
    height: 30px;
    background: #ffb3d9;
    animation-duration: 8s;
  }

  @keyframes float {
    0% {
      transform: translateY(0px);
    }
    50% {
      transform: translateY(-20px);
    }
    100% {
      transform: translateY(0px);
    }
  }

  .floating {
    position: absolute;
    z-index: 1;
    opacity: 0.1;
    font-size: 7rem;
    font-weight: bold;
    transform: rotate(-15deg);
  }

  .floating-1 {
    top: 10%;
    right: 10%;
  }

  .floating-2 {
    bottom: 10%;
    left: 5%;
  }

  // 可爱元素
  .cute-corner {
    position: absolute;
    width: 20px;
    height: 20px;
  }

  .top-left {
    top: 0;
    left: 0;
    border-top: 4px solid #ff9ecb;
    border-left: 4px solid #ff9ecb;
    border-top-left-radius: 10px;
  }

  .top-right {
    top: 0;
    right: 0;
    border-top: 4px solid #ff9ecb;
    border-right: 4px solid #ff9ecb;
    border-top-right-radius: 10px;
  }

  .bottom-left {
    bottom: 0;
    left: 0;
    border-bottom: 4px solid #ff9ecb;
    border-left: 4px solid #ff9ecb;
    border-bottom-left-radius: 10px;
  }

  .bottom-right {
    bottom: 0;
    right: 0;
    border-bottom: 4px solid #ff9ecb;
    border-right: 4px solid #ff9ecb;
    border-bottom-right-radius: 10px;
  }

  // 响应式调整
  @media (max-width: 500px) {
    .time-display .current-date {
      font-size: 1.2rem;
    }

    .time-display .current-time {
      font-size: 1.8rem;
    }

    .event-card .event-name {
      font-size: 1.2rem;
    }

    .dialog-content .form-label {
      font-size: 1rem;
    }
  }
}
</style>
