<template>
  <div class="home" style ="padding: 10px">
    <!-- 搜索-->
    <div style="margin: 10px 0;">
      <el-form inline="true" size="small" >
        <el-form-item label="ISBN" >
          <el-input v-model="search1" placeholder="Please enter ISBN"  clearable>
            <template #prefix><el-icon class="el-input__icon"><search/></el-icon></template>
          </el-input>
        </el-form-item >
        <el-form-item label="Title" >
          <el-input v-model="search2" placeholder="Please enter title"  clearable>
            <template #prefix><el-icon class="el-input__icon"><search /></el-icon></template>
          </el-input>
        </el-form-item >
        <el-form-item label="Borrower" v-if="user.role == 1">
          <el-input v-model="search3" placeholder="Please enter borrower"  clearable>
            <template #prefix><el-icon class="el-input__icon"><search /></el-icon></template>
          </el-input>
        </el-form-item >
        <el-form-item>
          <el-button type="primary" style="margin-left: 1%" @click="load" size="mini">Search</el-button>
        </el-form-item>
        <el-form-item>
          <el-button size="mini"  type="danger" @click="clear">Reset</el-button>
        </el-form-item>
      </el-form>
    </div>
    <!-- 按钮-->
    <div style="margin: 10px 0;" >
      <el-popconfirm title="Please confirm to delete" @confirm="deleteBatch" v-if="user.role == 1">
        <template #reference>
          <el-button type="danger" size="mini" >Batch Delete</el-button>
        </template>
      </el-popconfirm>
      <el-popconfirm title="Please confirm to return" @confirm="returnBatch" v-if="user.role == 1">
        <template #reference>
          <el-button type="primary" size="mini" >Batch Return</el-button>
        </template>
      </el-popconfirm>
    </div>
    <!-- 数据字段-->
    <el-table :data="tableData" stripe border="true" @selection-change="handleSelectionChange" style="margin-top: 10px;">
      <el-table-column v-if="user.role ==1"
          type="selection"
          width="55">
      </el-table-column>
      <el-table-column prop="bookid" width="50" label="ID" />
      <el-table-column prop="isbn" label="ISBN" sortable />
      <el-table-column prop="bookName" label="Title" />
      <el-table-column prop="nickName" label="Borrower" v-if="user.role==1"/>
      <el-table-column prop="lendtime" label="Borrow Time" />
      <el-table-column prop="deadtime" label="Deadline" />
      <el-table-column prop="prolong" label="Renewal Time" />
      <el-table-column prop="remainTime" label="Remain Time" />
      <el-table-column fixed="right" label="Options" >
        <template v-slot="scope">
          <el-button  size="mini" @click ="handleEdit(scope.row)" v-if="user.role == 1">Modify</el-button>
          <el-popconfirm title="Please confirm to return" @confirm="handlereturn(scope.row.bookid)" v-if="user.role == 1">
            <template #reference>
              <el-button type="primary" size="mini">Return</el-button>
            </template>
          </el-popconfirm>
          <el-popconfirm title="Please confirm to delete" @confirm="handleDelete(scope.row) " v-if="user.role == 1">
            <template #reference>
              <el-button type="danger" size="mini" >Delete</el-button>
            </template>
          </el-popconfirm>
          <el-popconfirm title="Please confirm to renew(Renew once to extend for 30 days)" @confirm="handlereProlong(scope.row)" v-if="user.role == 2" :disabled="scope.row.prolong == 0">
            <template #reference>
              <el-button type="danger" size="mini" :disabled="scope.row.prolong == 0" >Renew</el-button>
            </template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <!--    分页-->
    <div style="margin: 10px 0">
      <el-pagination
          v-model:currentPage="currentPage"
          :page-sizes="[5, 10, 20]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
      >
      </el-pagination>

      <el-dialog v-model="dialogVisible2" title="Modify Borrow Information" width="30%">
        <el-form :model="form" label-width="120px">

          <el-form-item label="ISBN">
            <el-input style="width: 80%" v-model="form.isbn"></el-input>
          </el-form-item>
          <el-form-item label="Title">
            <el-input style="width: 80%" v-model="form.bookName"></el-input>
          </el-form-item>
          <el-form-item label="Borrower">
            <el-input style="width: 80%" v-model="form.nickName"></el-input>
          </el-form-item>
          <el-form-item label="Renewal Time">
            <el-input style="width: 80%" v-model="form.prolong"></el-input>
          </el-form-item>
        </el-form>
        <template #footer>
      <span class="dialog-footer">
        <el-button @click="dialogVisible2 = false">Cancel</el-button>
        <el-button type="primary" @click="save">Save</el-button>
      </span>
        </template>
      </el-dialog>

    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import request from "../utils/request";
import {ElMessage} from "element-plus";
import moment from "moment";
export default {
  created(){
    let userStr = sessionStorage.getItem("user") ||"{}"
    this.user = JSON.parse(userStr)
    this.load()
  },
  name: 'LBookwithuser',
  methods: {
    handleSelectionChange(val){
      this.forms = val
    },
    deleteBatch(){
      if (!this.forms.length) {
        ElMessage.warning("Please choose one at least")
        return
      }
    //  一个小优化，直接发送这个数组，而不是一个一个的提交删除
      request.post("http://localhost:8181/bookwithuser/deleteRecords",this.forms).then(res =>{
        if(res.code === '0'){
          ElMessage.success("Successfully batch delete!")
          this.load()
        }
        else {
          ElMessage.error(res.msg)
        }
      })
    },
    async handlereturn(bookid){
      const res=await request.get("http://localhost:8181/book/searchById",{
        params:{
          id:bookid
        }
      })
      console.log(res)
      this.form = res.data
      this.form.status = "1"
      request.put("http://localhost:8181/book",this.form).then(res =>{
        console.log(res)
        if(res.code == 0){
          ElMessage({
            message: 'Successfully return!',
            type: 'success',
          })
        }
        else {
          ElMessage.error(res.msg)
        }
        //
        this.form3.isbn = this.form.isbn
        let endDate = moment(new Date()).format("yyyy-MM-DD HH:mm:ss")
        this.form3.returnTime = endDate
        this.form3.status = "1"
        this.form3.borrownum = this.form.borrownum
        this.form3.bookid=bookid
        request.put("http://localhost:8181/LendRecord1/",this.form3).then(res =>{
          console.log(res)
          let form3 ={};
          form3.isbn = this.form.isbn;
          form3.bookName = name;
          form3.id = this.user.id;
          form3.lendtime = endDate;
          form3.deadtime = endDate;
          form3.prolong  = 1;
          form3.bookid=bookid;
          console.log(form3)
          request.post("http://localhost:8181/bookwithuser/deleteRecord",form3).then(res =>{
            console.log(res)
            this.load()
          })
        })
      })
      // this.form3.isbn = isbn
      // this.form3.readerId = this.user.id
      // let endDate = moment(new Date()).format("yyyy-MM-DD HH:mm:ss")
      // this.form3.returnTime = endDate
      // this.form3.status = "1"
      // console.log(bn)
      // this.form3.borrownum = bn
      // request.put("/LendRecord1/",this.form3).then(res =>{
      //   console.log(res)
      // })
      // let form3 ={};
      // form3.isbn = isbn;
      // form3.bookName = name;
      // form3.nickName = this.user.username;
      // form3.id = this.user.id;
      // form3.lendtime = endDate;
      // form3.deadtime = endDate;
      // form3.prolong  = 1;
      // request.post("/bookwithuser/deleteRecord",form3).then(res =>{
      //   console.log(res)
      //   this.load()
      // })
    },
    returnBatch(){
      for(let i=0;i<this.forms.length;i++){
        this.handlereturn(this.forms[i].bookid)
      }
    },
    load(){
      if(this.user.role == 1){
        request.get("http://localhost:8181/bookwithuser",{
          params:{
            pageNum: this.currentPage,
            pageSize: this.pageSize,
            search1: this.search1,
            search2: this.search2,
            search3: this.search3,
          }
        }).then(res =>{
          console.log(res)
          this.tableData = res.data.records
          this.total = res.data.total
          this.tableData.forEach(item=>{
            const currentTime=new Date()
            const deadline=new Date(item.deadtime)
            const diffInMilliseconds = deadline-currentTime
            const remainTime = Math.ceil(diffInMilliseconds / (1000 * 60 * 60 * 24))
            item.remainTime=remainTime
          })
        })
      }
      else {
        request.get("http://localhost:8181/bookwithuser",{
          params:{
            pageNum: this.currentPage,
            pageSize: this.pageSize,
            search1: this.search1,
            search2: this.search2,
            search3: this.user.id,
          }
        }).then(res =>{
          console.log(res)
          this.tableData = res.data.records
          this.total = res.data.total
          this.tableData.forEach(item=>{
            const currentTime=new Date()
            const deadline=new Date(item.deadtime)
            const diffInMilliseconds = deadline-currentTime
            const remainTime = Math.ceil(diffInMilliseconds / (1000 * 60 * 60 * 24))
            item.remainTime=remainTime
          })
        })
      }
    },
    clear(){
      this.search1 = ""
      this.search2 = ""
      this.search3 = ""
      this.load()
    },
    handleDelete(row){
      const form3 = JSON.parse(JSON.stringify(row))
      request.post("http://localhost:8181/bookwithuser/deleteRecord",form3).then(res =>{
        console.log(res)
        if(res.code == 0 ){
          ElMessage.success("Successfully delete!")
        }
        else
          ElMessage.error(res.msg)
        this.load()
      })
    },
    handlereProlong(row){
      var nowDate = new Date(row.deadtime);
      nowDate.setDate(nowDate.getDate()+30);
      row.deadtime = moment(nowDate).format("yyyy-MM-DD HH:mm:ss");
      row.prolong = row.prolong -1;
      request.post("http://localhost:8181/bookwithuser",row).then(res =>{
        console.log(res)
        if(res.code == 0){
          ElMessage({
            message: 'Successfully renew!',
            type: 'success',
          })
        }
        else {
          ElMessage.error(res.msg)
        }
        this.load()
        this.dialogVisible2 = false
      })
    },
    save(){
      //ES6语法
      //地址,但是？IP与端口？+请求参数
      // this.form?这是自动保存在form中的，虽然显示时没有使用，但是这个对象中是有它的
        request.post("http://localhost:8181/bookwithuser",this.form).then(res =>{
          console.log(res)
          if(res.code == 0){
            ElMessage({
              message: 'Successfully modify!',
              type: 'success',
            })
          }
          else {
            ElMessage.error(res.msg)
          }
          this.load()
          this.dialogVisible2 = false
        })
    },

    handleEdit(row){
      this.form = JSON.parse(JSON.stringify(row))
      this.dialogVisible2 = true
    },
    handleSizeChange(pageSize){
      this.pageSize = pageSize
      this.load()
    },
    handleCurrentChange(pageNum){
      this.pageNum = pageNum
      this.load()
    },

  },
  data() {
    return {
      form: {},
      form2:{},
      form3:{},
      dialogVisible: false,
      dialogVisible2: false,
      search1:'',
      search2:'',
      search3:'',
      total:10,
      currentPage:1,
      pageSize: 10,
      tableData: [],
      user:{},
      forms:[],
      isbns:"",
      isbn:[]
    }
  },
}
</script>
