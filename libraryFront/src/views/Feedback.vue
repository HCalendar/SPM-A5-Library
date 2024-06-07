<template>
  <div>
    <el-container>
      <el-header>
        <div class="content-container">
          <div class="center-text">Feedback</div>
          <el-button type="text" class="right-button" @click="back">Return</el-button>
        </div>
      </el-header>
      <el-main>
        <div>
          <el-card style="width: 80%; margin-left: 120px; margin-top: 40px; background: papayawhip" v-if="this.role !== 1" >
            <h2 style="padding: 20px">Write down your advice:</h2>
            <el-form :model="form" ref="form" label-width="70px">
              <el-form-item label="">
                <el-input type="textarea" style="width: 90%;" :rows="2" v-model="comment"></el-input>
              </el-form-item>
            </el-form>
            <div style="text-align: center">
              <el-button type="primary" @click="addFeedback">Submit</el-button>
            </div>
          </el-card>
        </div>
        <div>
          <SingleFeedback v-for="(item) in infos" :key="item.id" :info="item"/>
        </div>
      </el-main>
    </el-container>
  </div>
</template>

<script>

import request from "../utils/request";
import {ElMessage} from "element-plus";
import SingleFeedback from "@/views/SingleFeedback.vue";

export default {
  components: {SingleFeedback},
  created(){
    let userStr = sessionStorage.getItem("user") ||"{}"
    this.user = JSON.parse(userStr)
    this.role=this.user.role
    this.showComment()
  },
  data(){
    return {
      form:{},
      title:"",
      comment:"",
      infos:[],
      role:"",
    }
  },
  name: 'LFeedback',
  methods: {
    back(){
      window.history.back()
    },
    addFeedback(){
      this.form.userid=this.user.id;
      this.form.content=this.comment;
      this.form.backcontent="";
      this.form.adminname="";

      request.post('http://localhost:8181/feedback/insertNew', this.form).then(res => {
        console.log(res);
        if (res.code==0) {
          ElMessage({
            message: 'Successfully submit!',
            type: 'success',
          })
          this.clearComment()
          window.location.reload()
        } else {
          ElMessage.error(res.msg)
        }
      }).catch(error => {
        console.error(error); // 打印任何请求错误
        alert('An error occurred while adding the comment.');
      })
    },
    clearComment(){
      this.comment=''
    },
    showComment(){
      console.log(this.role)
      request.get('http://localhost:8181/feedback/selectByUserId',{
        params:{
          userid: this.role === 1 ? 0 : this.user.id
        }
      },this.form).then(res => {
        this.infos = res.data;
        console.log(res.data);
      })
    }
  }
}
</script>

<style scoped>
.content-container {
  display: flex;
  align-items: center; /* 垂直居中 */
  justify-content: center; /* 水平居中，但是这里的中心指的是内容容器本身的中心，而不是页面中心 */
}
.center-text {
  flex-shrink: 0;
  margin-right: 10px;
  line-height:1.5;
  font-size:50px;
  font-weight: bold;
}
.right-button{
  margin-left: auto;
}
.title{
  font-size:20px;
  font-weight: bold;
  color:grey;
}
</style>
