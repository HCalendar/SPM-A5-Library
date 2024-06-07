<template>
  <div class="info-container">
    <el-card class="card-with-button" style="width: 80%;margin-left: 120px; margin-top: 10px;background: beige">
      <div class="card-content">
        <h3>User Name: {{ info.username }}</h3>
        <p>comment: {{ info.content }}</p>
      </div>
      <div class="card-actions" v-if="info.userid.toLocaleString() === this.userid.toLocaleString() || this.role === 1">
        <el-button type="danger" size="mini" @click="deleteComment(info.id)">Delete</el-button>
      </div>
    </el-card>
  </div>
</template>

<script>
import request from "@/utils/request";
import {ElMessage} from "element-plus";

export default {
  props: ['info'],
  created(){
    let userStr = sessionStorage.getItem("user") ||"{}"
    this.user = JSON.parse(userStr)
    this.userid=this.user.id
    this.role=this.user.role
  },
  methods:{
    deleteComment(id){
      console.log(id)
      request.delete("http://localhost:8181/comment/deleteRecord/" + id ).then(res =>{
        console.log(res)
        if(res.code == 0 ){
          ElMessage.success("Successfully delete!")
        }
        else
          ElMessage.error(res.msg)
        window.location.reload()
      })
    }
  },
  data(){
    return{
      userid:"",
      role:0
    }
  },
}
</script>

<style scoped>
.card-with-button {
  display: flex;
  flex-direction: column; /* 默认是column，但这里明确一下 */
}

.card-content {
  /* 这里可以根据需要设置内容的样式 */
  flex: 1; /* 让内容占据剩余空间 */
}

.card-actions {
  display: flex;
  justify-content: flex-end; /* 将子元素（按钮）对齐到右边 */
  margin-top: auto; /* 将动作栏推到card的底部（如果有垂直空间的话） */
}
</style>
