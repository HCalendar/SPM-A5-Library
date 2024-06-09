<template>
  <div class="home" style ="padding: 10px">

    <!-- 搜索-->
    <div style="margin: 10px 0;">
      <el-form inline="true" size="small">
        <el-form-item label="Book ISBN" >
          <el-input v-model="search1" placeholder="Please enter book ISBN"  clearable>
            <template #prefix><el-icon class="el-input__icon"><search/></el-icon></template>
          </el-input>
        </el-form-item >
        <el-form-item label="Title" >
          <el-input v-model="search2" placeholder="Please enter title"  clearable>
            <template #prefix><el-icon class="el-input__icon"><search /></el-icon></template>
          </el-input>
        </el-form-item >
        <el-form-item label="Author" >
          <el-input v-model="search3" placeholder="Please enter author"  clearable>
            <template #prefix><el-icon class="el-input__icon"><search /></el-icon></template>
          </el-input>
        </el-form-item >
        <el-form-item>
          <el-button type="primary" style="margin-left: 1%" @click="load" size="mini" >
            <svg-icon iconClass="search"/>Search</el-button>
        </el-form-item>
        <el-form-item>
          <el-button size="mini"  type="danger" @click="clear">Reset</el-button>
        </el-form-item>
        <el-form-item style="float: right" v-if="numOfOutDataBook!=0">
          <el-popconfirm
              confirm-button-text="View"
              cancel-button-text="Cancel"
              :icon="InfoFilled"
              icon-color="red"
              title="You have book overdue,pleas return it as soon as possible"
              @confirm="toLook"
          >

            <template #reference>
              <el-button  type="warning">Overdue Notice</el-button>
            </template>
          </el-popconfirm>
        </el-form-item>
      </el-form>
    </div>
    <!-- 数据字段-->
    <el-table :data="tableData" stripe border="true" @selection-change="handleSelectionChange">
      <el-table-column prop="id" width="50" label="ID" />
      <el-table-column fixed="left" prop="isLike" label="Like" width="55" v-if="user.role !==1">
        <template v-slot="scope">
          <star-filled v-if="scope.row.isLike===true" color="yellow" @click="onLike(scope.row)"></star-filled>
          <star v-if="scope.row.isLike===false" color="yellow" class="el-icon-star-on" @click="onLike(scope.row)"></star>
        </template>
      </el-table-column>
      <el-table-column prop="isbn" label="ISBN" sortable />
      <el-table-column prop="name" label="Title" />
      <el-table-column prop="author" label="Author" />
      <el-table-column prop="publisher" label="Publisher" />
      <el-table-column prop="createTime" label="PublicationTime" sortable/>

      <el-table-column prop="location" label="Location" />

      <el-table-column prop="status" label="Status">
        <template v-slot="scope">
          <el-tag v-if="scope.row.status == 0" type="warning">Borrowed</el-tag>
          <el-tag v-else type="success">Not Borrowed</el-tag>
        </template>
      </el-table-column>


      <el-table-column fixed="right" label="Options" >
        <template v-slot="scope">
          <el-button size="mini" @click ="handlelend(scope.row.id,scope.row.isbn,scope.row.name,scope.row.borrownum)" v-if="user.role == 2" :disabled="scope.row.status == 0||numOfOutDataBook!=0">Borrow</el-button>
          <el-button type="primary" size="mini" @click="$router.push('/comment/'+scope.row.name+'/'+scope.row.isbn)">View Comments</el-button>
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
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import request from "../utils/request";
import {ElMessage} from "element-plus";
import moment from "moment";
import {StarFilled} from "@element-plus/icons-vue";
export default {
  components: {StarFilled},
  created(){
    let userStr = sessionStorage.getItem("user") ||"{}"
    this.user = JSON.parse(userStr)
    this.load()
  },
  name: 'LLike',
  methods: {
    // (this.isbnArray.indexOf(scope.row.isbn)) == -1
    handleSelectionChange(val){
      this.ids = val.map(v =>v.id)
    },
    load(){
      this.numOfOutDataBook =0;
      this.outDateBook =[];
      request.get("http://localhost:8181/book/all").then(res =>{
        console.log(res)
        let r=res
        request.get("http://localhost:8181/like",{
          params:{
            userid:this.user.id
          }
        }).then(res=>{
          console.log(res)
          let j=0
          res.forEach(item => {
            for (let i = 0; i < r.data.length; i++) {
              if (r.data[i].id === item.bookid) {
                this.tableData[j]=r.data[i]
                this.tableData[j].isLike=true;
                j++;
                break;
              }
            }
          })
          this.total=this.tableData.total
        })
      })
    },
    clear(){
      this.search1 = ""
      this.search2 = ""
      this.search3 = ""
      this.load()
    },
    handlelend(id,isbn,name,bn){
      if(this.number ==5){
        ElMessage.warning("You cannot borrow more books!")
        return;
      }
      if(this.numOfOutDataBook !=0){
        ElMessage.warning("You cannot borrow more books before your return the book overdue!")
        return;
      }
      this.form.status = "0"
      this.form.id = id
      this.form.borrownum = bn+1
      console.log(bn)
      request.put("http://localhost:8181/book",this.form).then(res =>{
        console.log(res)
        if(res.code == 0){
          ElMessage({
            message: 'Successfully borrow!',
            type: 'success',
          })
        }
        else {
          ElMessage.error(res.msg)
        }
      })
      this.form2.status = "0"
      this.form2.isbn = isbn
      this.form2.bookname = name
      this.form2.readerId = this.user.id
      this.form2.borrownum = bn+1
      this.form2.bookid=id
      console.log(this.form2.borrownum)
      console.log(this.user)
      let startDate = moment(new Date()).format("yyyy-MM-DD HH:mm:ss");
      this.form2.lendTime = startDate
      console.log(this.user)
      request.post("http://localhost:8181/LendRecord",this.form2).then(res =>{
        console.log(res)
        this.load();

      })
      let form3 ={};
      form3.isbn = isbn;
      form3.bookName = name;
      form3.nickName = this.user.username;
      form3.id = this.user.id;
      form3.bookid=id;
      form3.lendtime = startDate;
      let nowDate = new Date(startDate);
      nowDate.setDate(nowDate.getDate()+30);
      form3.deadtime = moment(nowDate).format("yyyy-MM-DD HH:mm:ss");
      form3.prolong  = 1;
      request.post("http://localhost:8181/bookwithuser/insertNew",form3).then(res =>{
        console.log(res)
        this.load()
      })
    },
    handleSizeChange(pageSize){
      this.pageSize = pageSize
      this.load()
    },
    handleCurrentChange(pageNum){
      this.pageNum = pageNum
      this.load()
    },
    onLike(row){
      row.isLike=!row.isLike
      this.like.bookid=row.id
      this.like.userid=this.user.id
      if(row.isLike){
        request.post("http://localhost:8181/like/save",this.like).then(res=>{
          console.log(res)
          if(res.code == 0){
            ElMessage({
              message: 'Successfully like!',
              type: 'success',
            })
          }
          else{
            ElMessage.error()
          }
        })
      }
      else{
        request.post("http://localhost:8181/like/delete",this.like).then(res=>{
          console.log(res)
          if(res.code == 0){
            ElMessage({
              message: 'Successfully cancel like!',
              type: 'success',
            })
          }
          else{
            ElMessage.error()
          }
        })
      }
      this.load()
      window.location.reload()
    }
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
      number:0,
      bookData:[],
      isbnArray:[],
      outDateBook:[],
      numOfOutDataBook: 0,
      dialogVisible3 : true,
      dialogVisible4: false,
      currentBookId: null,
      money:0,
      isbn:[],
      wrongAdd:[],
      like:{}
    }
  },
}
</script>
<style>
.text-center{
  text-align: center;
}
</style>
