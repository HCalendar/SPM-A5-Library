<template>
<div class="login-container">
    <el-form ref="form" :model="form"   :rules="rules" class="login-page">
      <div class="flex-container">
        <h2 class="title" style="margin-bottom: 20px">Login</h2>
        <el-form-item><el-button type="text" @click="$router.push('/guest')">Only View Books</el-button></el-form-item>
      </div>
      <el-form-item prop="username" >
        <el-input v-model="form.username"  clearable>
          <template #prefix>
            <el-icon class="el-input__icon"><User /></el-icon>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input v-model="form.password"  clearable show-password>
          <template #prefix>
            <el-icon class="el-input__icon"><Lock /></el-icon>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item>
        <div style="display: flex">
          <el-input  v-model="form.validCode" style="width: 45%;" placeholder="Please enter verification code"></el-input>
          <ValidCode @input="createValidCode" style="width: 50%"/>
        </div>
      </el-form-item>
      <el-form-item >
        <el-button type="primary"  style=" width: 100%" @click="login">Login</el-button>
      </el-form-item>
      <el-form-item><el-button type="text" @click="$router.push('/register')">Go to register >> </el-button></el-form-item>
    </el-form>
</div>

</template>

<script>
import request from "../utils/request";
import {ElMessage} from "element-plus";
import ValidCode from "../components/Validate";

export default {
  name: "LLogin",
  components:{
    ValidCode
  },
  data() {
    return {
      validCode: '',//通过valicode获取的验证码
      form: {},
      rules: {
        username: [
          {
            required: true,
            message: 'Please enter username',
            trigger: 'blur',
          }
        ],
        password: [
          {
            required: true,
            message: 'Please enter password',
            trigger: 'blur',
          }
        ]

      }

    }
  },
  methods: {
    createValidCode(data){
      this.validCode = data
    },
    login(){
      this.$refs['form'].validate((valid) => {
        if (valid) {
          if (!this.form.validCode) {
            ElMessage.error("Please enter verification code")
            return
          }
          if(this.form.validCode.toLowerCase() !== this.validCode.toLowerCase()) {
            ElMessage.error("Wrong Verification Code!")
            return
          }

          request.post("http://localhost:8181/user/login", this.form).then(res => {
            if (res.code == 0) {
              ElMessage.success("Successfully Login!")
              sessionStorage.setItem("user",JSON.stringify(res.data))//缓存用户信息
              this.$router.push("/welcome")
            } else {
              ElMessage.error(res.msg)
            }
          })
        }
      })

    }
  }
}

</script>

<style scoped>
.login-container {
  position: fixed;
  width: 100%;
  height: 100vh;
  background: url('../img/bg2.svg');
  background-size: contain;
  overflow: hidden;
}
.login-page {
  border-radius: 5px;
  margin: 180px auto;
  width: 350px;
  padding: 35px 35px 15px;
  background: #fff;
  border: 1px solid #eaeaea;
  box-shadow: 0 0 25px #cac6c6;
}
.flex-container {
  display: flex;
  justify-content: space-between; /* 或者使用其他值，比如 space-around, center 等 */
  align-items: center; /* 如果需要垂直居中 */
}
</style>
