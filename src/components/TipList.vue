<script setup lang="ts">
import { ref, onMounted, onUnmounted } from "vue";
import { ElMessageBox } from "element-plus";
import { Edit, Delete } from "@element-plus/icons-vue";

interface Event {
  title: string;
  dateRange: [Date, Date];
  status: "before" | "during" | "after";
  remainingTime: string;
}

const showDialog = ref(false);
const form = ref({
  title: "",
  dateRange: [] as Date[],
});

const events = ref<Event[]>([]);
let updateTimer: number | null = null;
let cleanupTimer: number | null = null;

const addEvent = () => {
  if (!form.value.title || !form.value.dateRange.length) {
    ElMessageBox.alert("请填写完整信息", "提示");
    return;
  }

  const startDate = new Date(form.value.dateRange[0]);
  const endDate = new Date(form.value.dateRange[1]);
  const currentDate = new Date();

  let status: "before" | "during" | "after" = "before";
  if (currentDate < startDate) {
    status = "before";
  } else if (currentDate > endDate) {
    status = "after";
  } else {
    status = "during";
  }

  events.value.push({
    title: form.value.title,
    dateRange: [startDate, endDate],
    status,
    remainingTime: calculateRemainingTime(startDate, status),
  });

  form.value.title = "";
  form.value.dateRange = [];
  showDialog.value = false;
};

const editEvent = (index: number) => {
  ElMessageBox.prompt("请输入新的标题", "编辑假期", {
    inputValue: events.value[index].title,
  })
    .then(({ value }) => {
      if (value) {
        events.value[index].title = value;
      }
    })
    .catch(() => {
      // 用户取消编辑
    });
};

const deleteEvent = (index: number) => {
  ElMessageBox.confirm("确定要删除这个假期吗？", "确认删除", {
    type: "warning",
  })
    .then(() => {
      events.value.splice(index, 1);
    })
    .catch(() => {
      // 用户取消删除
    });
};

const calculateRemainingTime = (startDate: Date, status: string): string => {
  if (status !== "before") return "";
  const now = new Date();
  const diff = startDate.getTime() - now.getTime();
  if (diff <= 0) {
    return "已开始";
  }
  const days = Math.floor(diff / (1000 * 60 * 60 * 24));
  const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
  const second = Math.floor((diff % (1000 * 60)) / 1000);
  return `${days}天 ${hours}小时 ${minutes}分钟 ${second}秒`;
};

const formatDate = (date: Date) => {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0"); // 月份从0开始，所以需要+1
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

const updateEvents = () => {
  events.value.forEach((event) => {
    const currentDate = new Date();
    const startDate = new Date(event.dateRange[0]);
    const endDate = new Date(event.dateRange[1]);

    if (currentDate < startDate) {
      event.status = "before";
      event.remainingTime = calculateRemainingTime(startDate, "before");
    } else if (currentDate > endDate) {
      event.status = "after";
    } else {
      event.status = "during";
    }
  });
};

const cleanupExpiredEvents = () => {
  events.value = events.value.filter((event) => {
    const endDate = new Date(event.dateRange[1]);
    return new Date() <= endDate;
  });
};

onMounted(() => {
  updateTimer = setInterval(updateEvents, 1000);
  cleanupTimer = setInterval(cleanupExpiredEvents, 60000);
});

onUnmounted(() => {
  if (updateTimer) clearInterval(updateTimer);
  if (cleanupTimer) clearInterval(cleanupTimer);
});
</script>

<template>
  <div class="tip-list-container">
    <el-button type="primary" @click="showDialog = true" class="add-btn"
      >添加假期</el-button
    >

    <el-dialog
      title="添加假期"
      v-model="showDialog"
      width="90%"
      class="event-dialog"
    >
      <el-form :model="form" label-width="80px">
        <el-form-item label="标题">
          <el-input
            v-model="form.title"
            autocomplete="off"
            placeholder="请输入假期标题"
          ></el-input>
        </el-form-item>
        <el-form-item label="日期范围">
          <el-date-picker
            v-model="form.dateRange"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            style="width: 100%"
          ></el-date-picker>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="showDialog = false">取消</el-button>
          <el-button type="primary" @click="addEvent">添加</el-button>
        </div>
      </template>
    </el-dialog>

    <div class="events-container">
      <el-card
        v-for="(item, index) in events"
        :key="index"
        class="event-card"
        shadow="hover"
      >
        <div class="event-content">
          <div class="event-header">
            <h3 class="event-title">{{ item.title }}</h3>
            <div class="event-actions">
              <el-button size="small" @click="editEvent(index)" circle>
                <el-icon><Edit /></el-icon>
              </el-button>
              <el-button
                size="small"
                type="danger"
                @click="deleteEvent(index)"
                circle
              >
                <el-icon><Delete /></el-icon>
              </el-button>
            </div>
          </div>
          <div class="event-date">
            {{ formatDate(item.dateRange[0]) }} 至
            {{ formatDate(item.dateRange[1]) }}
          </div>
          <div class="event-status">
            <span v-if="item.status === 'before'" class="status-before">
              剩余时间: {{ item.remainingTime }}
            </span>
            <span v-else-if="item.status === 'during'" class="status-during">
              🎉 正在享受{{ item.title }}
            </span>
          </div>
        </div>
      </el-card>

      <div v-if="events.length === 0" class="empty-state">
        <p>暂无假期，点击上方按钮添加假期</p>
      </div>
    </div>
  </div>
</template>

<style scoped lang="less">
.tip-list-container {
  padding: 16px;
  max-width: 800px;
  margin: 0 auto;
}

.add-btn {
  width: 100%;
  margin-bottom: 20px;
  height: 44px;
  font-size: 16px;
}

::v-deep .event-dialog {
  max-width: 500px;
}

.events-container {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.event-card {
  transition: all 0.3s ease;
}

.event-card:hover {
  transform: translateY(-2px);
}

.event-content {
  padding: 8px 0;
}

.event-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.event-title {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #333;
  flex: 1;
}

.event-actions {
  display: flex;
  gap: 8px;
}

.event-date {
  color: #666;
  font-size: 14px;
  margin-bottom: 8px;
}

.event-status {
  font-size: 14px;
}

.status-before {
  color: #409eff;
  font-weight: 500;
}

.status-during {
  color: #67c23a;
  font-weight: 600;
}

.empty-state {
  text-align: center;
  padding: 40px 0;
  color: #999;
}

/* 移动端优化 */
@media (max-width: 768px) {
  .tip-list-container {
    padding: 12px;
  }

  .event-title {
    font-size: 16px;
  }

  .event-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }

  .event-actions {
    align-self: flex-end;
  }

  .event-date {
    font-size: 12px;
  }

  .event-status {
    font-size: 12px;
  }
}

@media (max-width: 480px) {
  ::v-deep .event-dialog {
    width: 95% !important;
  }

  .dialog-footer {
    display: flex;
    gap: 8px;
  }

  .dialog-footer .el-button {
    flex: 1;
  }
}
</style>
