<template>
<div  class="login-container"  >
    <el-form ref="form" :model="form"    :rules="rules" class="login-page">
      <h2 class="title" style="margin-bottom: 20px">Patron Register</h2>
      <el-form-item prop="username" >
        <el-input v-model="form.username" placeholder="Please enter username" clearable >
          <template #prefix>
            <el-icon class="el-input__icon"><User/></el-icon>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input v-model="form.password"  placeholder="Please enter password" clearable show-password>
          <template #prefix>
            <el-icon class="el-input__icon"><Lock /></el-icon>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item prop="confirm">
        <el-input v-model="form.confirm" placeholder="Enter again" clearable show-password>
          <template #prefix>
            <el-icon class="el-input__icon"><Lock /></el-icon>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item prop="role">
        <el-radio v-model="form.role" label="2">Patron</el-radio>
        <el-radio v-model="form.role" label="1">Librarian</el-radio>
      </el-form-item>
      <el-form-item prop="authorize" v-if="form.role==1">
        <el-input v-model="form.authorize" placeholder="Please enter librarian registration code" clearable show-password>
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
        <el-button type="primary" style=" width: 100%" @click="register">Register</el-button>
      </el-form-item>
      <el-form-item><el-button type="text" @click="$router.push('/login')">Go to login>> </el-button></el-form-item>
    </el-form>
</div>

</template>

<script>
import request from "../utils/request";
import {ElMessage} from "element-plus";
import ValidCode from "../components/Validate";
export default {
  name: "LRegister",
  components:{
    ValidCode
  },
  data(){
    return{
      form:{},
      validCode: '',
      rules: {
        username: [
          {
            required: true,
            message: 'Please enter username',
            trigger: 'blur',
          },
          {
            min: 2,
            max: 13,
            message: 'Please enter it between 2 to 13',
            trigger: 'blur',
          },
        ],
        password: [
          {
            required: true,
            message: 'Please enter password',
            trigger: 'blur',
          }
        ],
      confirm:[
        {
          required:true,
          message:"Please enter again",
          trigger:"blur"
        }
      ],
        authorize:[
          {
            required:true,
            message:"Please enter registration code",
            trigger:"blur"
          }
        ],
      }
    }
    },

  methods:{
    createValidCode(data){
      this.validCode =data
    },
    register(){
      this.$refs['form'].validate((valid) => {
        if (valid) {
          if (!this.form.validCode) {
            ElMessage.error("Please enter verification code")
            return
          }
          if(this.form.validCode.toLowerCase() !== this.validCode.toLowerCase()) {
            ElMessage.error("Wrong verification code!")
            return
          }
          if(this.form.password != this.form.confirm)
          {
            ElMessage.error("The passwords entered twice are inconsistent!")
            return
          }
          if(this.form.role == 1 && this.form.authorize != "1234")
          {
            ElMessage.error("Wrong Registration Code!")
            return
          }
          request.post("http://localhost:8181/user/register",this.form).then(res=>{
            if(res.code == 0)
            {
              ElMessage.success("Successfully register!")
              this.$router.push("/login")
            }
            else {ElMessage.error(res.msg)}
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
  height: 100%;
  background: url('../img/bg2.svg');
  background-size: contain;
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
</style>
