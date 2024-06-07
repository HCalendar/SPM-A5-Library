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
    <!-- 按钮-->
    <div style="margin: 10px 0;" >
      <el-button type="primary" @click = "add" v-if="user.role == 1">Add</el-button>
      <el-popconfirm title="Please confirm to delete." @confirm="deleteBatch" v-if="user.role == 1">
        <template #reference>
          <el-button type="danger" size="mini" >Batch Delete</el-button>
        </template>
      </el-popconfirm>

    </div>
    <!-- 数据字段-->
    <el-table :data="tableData" stripe border="true" @selection-change="handleSelectionChange">
      <el-table-column v-if="user.role ==1"
                       type="selection"
                       width="55">
      </el-table-column>
      <el-table-column prop="isbn" label="ISBN" sortable />
      <el-table-column prop="name" label="Title" />
      <!--<el-table-column prop="price" label="Price" sortable/>-->
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
          <el-button  size="mini" @click ="handleEdit(scope.row)" v-if="user.role == 1">Modify</el-button>
          <el-popconfirm title="Please confirm to delete." @confirm="handleDelete(scope.row.id)" v-if="user.role == 1">
            <template #reference>
              <el-button type="danger" size="mini" >Delete</el-button>
            </template>
          </el-popconfirm>
          <el-button size="mini" @click ="handlelend(scope.row.id,scope.row.isbn,scope.row.name,scope.row.borrownum)" v-if="user.role == 2" :disabled="scope.row.status == 0||numOfOutDataBook!=0">Borrow</el-button>
          <el-button type="primary" size="mini" @click="$router.push('/comment/'+scope.row.name+'/'+scope.row.isbn)">View Comments</el-button>
          <el-button :type="buttonType" @click="toggleFavorite" size="mini">{{ buttonText }}</el-button>

        </template>
      </el-table-column>
    </el-table>

<!--测试,通知对话框-->
    <el-dialog
        v-model="dialogVisible3"
        v-if="numOfOutDataBook!=0"
        title="About Overdue"
        width="50%"
        :before-close="handleClose"
    >
        <el-table :data="outDateBook" style="width: 100%">
          <el-table-column prop="isbn" label="ISBN" />
          <el-table-column prop="bookName" label="Title" />
          <el-table-column prop="lendtime" label="Borrow Time" />
          <el-table-column prop="deadtime" label="Deadline" />
        </el-table>

      <template #footer>
      <span class="dialog-footer">
        <el-button type="primary" @click="$router.push('/penalty/'+this.money+'/'+this.penaltyid)"
        >Pay</el-button>
        <el-button type="primary" @click="dialogVisible3 = false"
        >Yes</el-button>
      </span>
      </template>
    </el-dialog>
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

      <el-dialog v-model="dialogVisible" title="Add Book" width="30%">
        <el-form :model="form" label-width="120px">
          <el-form-item label="Location">
            <el-input style="width: 80%" v-model="form.location"></el-input>
          </el-form-item>
          <el-form-item label="ISBN">
            <el-input type="textarea" style="width: 80%" v-model="this.isbns"></el-input>
          </el-form-item>
        </el-form>
        <p style="margin-left: 120px;">Enter ISBNs separated by ";"</p>
        <template #footer>
      <span class="dialog-footer">
        <el-button @click="dialogVisible = false">Cancel</el-button>
        <el-button type="primary" @click="save">Save</el-button>
      </span>
        </template>
      </el-dialog>
      <el-dialog v-model="dialogVisible4" title="Notice" width="50%">
        <p class="text-center" v-if="wrongAdd.length===0">All books are added successfully!</p>
        <p class="text-center" v-if="wrongAdd.length!==0">We can't find these books:</p>
        <p class="text-center" v-for="(item,index) in wrongAdd" :key="index">{{item}} </p>
        <template #footer>
      <span class="dialog-footer">
        <el-button @click="dialogVisible4 = false">Yes</el-button>
      </span>
        </template>
      </el-dialog>

      <el-dialog v-model="dialogVisible2" title="Modify Book Information" width="30%">
        <el-form :model="form" label-width="120px">

          <el-form-item label="ISBN">
            <el-input style="width: 80%" v-model="form.isbn"></el-input>
          </el-form-item>
          <el-form-item label="Title">
            <el-input style="width: 80%" v-model="form.name"></el-input>
          </el-form-item>
          <el-form-item label="Price">
            <el-input style="width: 80%" v-model="form.price"></el-input>
          </el-form-item>
          <el-form-item label="Author">
            <el-input style="width: 80%" v-model="form.author"></el-input>
          </el-form-item>
          <el-form-item label="Publisher">
            <el-input style="width: 80%" v-model="form.publisher"></el-input>
          </el-form-item>
          <el-form-item label="PublicationTime">
            <div>
              <el-date-picker value-format="YYYY-MM-DD" type="date" style="width: 80%" clearable v-model="form.createTime" ></el-date-picker>
            </div>
          </el-form-item>
        </el-form>
        <template #footer>
      <span class="dialog-footer">
        <el-button @click="dialogVisible = false">Cancel</el-button>
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
  props: {
    book: Object // 传入的图书对象
  },
  created() {
    let userStr = sessionStorage.getItem("user") || "{}"
    this.user = JSON.parse(userStr)
    this.calculate()
    this.load()
  },
  name: 'LBook',
  methods: {
    // (this.isbnArray.indexOf(scope.row.isbn)) == -1
    toggleFavorite(isbn) {
      this.isBookFavorite = !this.isBookFavorite;

      if (this.isBookFavorite) {
        request.get("http://localhost:8181/book", {
          params: {
            pageNum: this.currentPage,
            pageSize: this.pageSize,
            search1: this.search1,
            search2: this.search2,
            search3: this.search3,
          }
        }).then(res => {
          console.log(res)
          this.tableData = res.data.records
          this.total = res.data.total

          this.buttonType = 'success';
          this.buttonText = 'add to favorite';
          // 将图书信息添加到收藏中
          this.favoriteBooks.push(isbn);
        }).catch(error => {
          console.error(error);
        });
      } else {
        this.buttonType = 'warning';
        this.buttonText = 'remove from favorite';

        // 从收藏中移除图书信息
        const index = this.favoriteBooks.findIndex(book => book.isbn === isbn);
        if (index !== -1) {
          this.favoriteBooks.splice(index, 1);
        }
      }
    },

    handleSelectionChange(val)
    {
      this.ids = val.map(v => v.id)
    },

    deleteBatch() {
      if (!this.ids.length) {
        ElMessage.warning("Please choose one at least!")
        return
      }
      //  一个小优化，直接发送这个数组，而不是一个一个的提交删除
      request.post("http://localhost:8181/book/deleteBatch", this.ids).then(res => {
        if (res.code === '0') {
          ElMessage.success("Successfully batch delete!")
          this.load()
        } else {
          ElMessage.error(res.msg)
        }
      })
    },
    load() {
      this.numOfOutDataBook = 0;
      this.outDateBook = [];
      request.get("http://localhost:8181/book", {
        params: {
          pageNum: this.currentPage,
          pageSize: this.pageSize,
          search1: this.search1,
          search2: this.search2,
          search3: this.search3,
        }
      }).then(res => {
        console.log(res)
        this.tableData = res.data.records
        this.total = res.data.total
      })
      //
      if (this.user.role == 2) {
        request.get("http://localhost:8181/bookwithuser", {
          params: {
            pageNum: "1",
            pageSize: this.total,
            search1: "",
            search2: "",
            search3: this.user.id,
          }
        }).then(res => {
          console.log(res)
          this.bookData = res.data.records
          this.number = this.bookData.length;
          var nowDate = new Date();
          for (let i = 0; i < this.number; i++) {
            this.isbnArray[i] = this.bookData[i].isbn;
            let dDate = new Date(this.bookData[i].deadtime);
            if (dDate < nowDate) {
              this.outDateBook[this.numOfOutDataBook] = {
                isbn: this.bookData[i].isbn,
                bookName: this.bookData[i].bookName,
                deadtime: this.bookData[i].deadtime,
                lendtime: this.bookData[i].lendtime,
              };
              this.numOfOutDataBook = this.numOfOutDataBook + 1;
            }
          }
          console.log("in load():" + this.numOfOutDataBook);
        })
      }
      //
    },
    clear() {
      this.search1 = ""
      this.search2 = ""
      this.search3 = ""
      this.load()
    },
    handleDelete(id) {
      request.delete("http://localhost:8181/book/" + id).then(res => {
        console.log(res)
        if (res.code == 0) {
          ElMessage.success("Successfully delete!")
        } else
          ElMessage.error(res.msg)
        this.load()

      })
    },

    handlelend(id, isbn, name, bn) {
      if (this.number == 5) {
        ElMessage.warning("You cannot borrow more books!")
        return;
      }
      if (this.numOfOutDataBook != 0) {
        ElMessage.warning("You cannot borrow more books before your return the book overdue!")
        return;
      }
      this.form.status = "0"
      this.form.id = id
      this.form.borrownum = bn + 1
      console.log(bn)
      request.put("http://localhost:8181/book", this.form).then(res => {
        console.log(res)
        if (res.code == 0) {
          ElMessage({
            message: 'Successfully borrow!',
            type: 'success',
          })
        } else {
          ElMessage.error(res.msg)
        }
      })
      this.form2.status = "0"
      this.form2.isbn = isbn
      this.form2.bookname = name
      this.form2.readerId = this.user.id
      this.form2.borrownum = bn + 1
      console.log(this.form2.borrownum)
      console.log(this.user)
      let startDate = moment(new Date()).format("yyyy-MM-DD HH:mm:ss");
      this.form2.lendTime = startDate
      console.log(this.user)
      request.post("http://localhost:8181/LendRecord", this.form2).then(res => {
        console.log(res)
        this.load();

      })
      let form3 = {};
      form3.isbn = isbn;
      form3.bookName = name;
      form3.nickName = this.user.username;
      form3.id = this.user.id;
      form3.lendtime = startDate;
      let nowDate = new Date(startDate);
      nowDate.setDate(nowDate.getDate() + 30);
      form3.deadtime = moment(nowDate).format("yyyy-MM-DD HH:mm:ss");
      form3.prolong = 1;
      request.post("http://localhost:8181/bookwithuser/insertNew", form3).then(res => {
        console.log(res)
        this.load()
      })
    },
    add() {
      this.dialogVisible = true
      this.form = {}
    },
    async save() {
      //ES6语法
      //地址,但是？IP与端口？+请求参数
      // this.form?这是自动保存在form中的，虽然显示时没有使用，但是这个对象中是有它的
      if (this.form.id) {
        request.put("http://localhost:8181/book", this.form).then(res => {
          console.log(res)
          if (res.code == 0) {
            ElMessage({
              message: 'Successfully modify!',
              type: 'success',
            })
          } else {
            ElMessage.error(res.msg)
          }

          this.load()
          this.dialogVisible2 = false
        })
      } else {
        this.form.borrownum = 0
        this.form.status = 1
        this.isbn = this.isbns.split(';')
        this.wrongAdd = []
        for (let i = 0; i < this.isbn.length; i++) {
          const res = await request.get('https://apis.5share.site/books/?isbn=' + this.isbn[i])
          console.log(res)
          if (res.ret == true) {
            const bookInfo = res.info
            this.form.isbn = this.isbn[i]
            this.form.name = bookInfo.name
            this.form.price = 0
            this.form.author = bookInfo.authors
            this.form.publisher = bookInfo.publisher
            this.form.createTime = bookInfo.publishedDate
            const saveRes = request.post("http://localhost:8181/book", this.form)
            console.log(saveRes)
          }
          /*if(res.code == 1){
            const bookInfo=res.data
            console.log(bookInfo)
            this.form.isbn=this.isbn[i]
            this.form.name=bookInfo.title
            this.form.price=bookInfo.price
            this.form.author=bookInfo.author
            this.form.publisher=bookInfo.publisher
            this.form.createTime=bookInfo.pubdate
            console.log(this.form)
            const saveRes=request.post("http://localhost:8181/book",this.form)
            console.log(saveRes)
          }*/
          else {
            this.wrongAdd.push(this.isbn[i])
          }
        }
        this.dialogVisible = false
        this.dialogVisible4 = true
        this.load()
      }
      window.location.reload()
    },
    // formatter(row) {:formatter="formatter"
    //   return row.address
    // },

    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row))
      this.dialogVisible2 = true
    },
    handleSizeChange(pageSize) {
      this.pageSize = pageSize
      this.load()
    },
    handleCurrentChange(pageNum) {
      this.pageNum = pageNum
      this.load()
    },
    toLook() {
      this.dialogVisible3 = true;
    },
    calculate() {
      request.get("http://localhost:8181/bookwithuser", {
        params: {
          pageNum: this.currentPage,
          pageSize: this.pageSize,
          search1: this.search1,
          search2: this.search2,
          search3: this.search3,
        }
      }).then(res => {
        console.log(res)
        this.tableData = res.data.records
        this.total = res.data.total
        this.tableData.forEach(item => {
          const currentTime = new Date()
          const deadline = new Date(item.deadtime)
          const diffInMilliseconds = Math.abs(deadline - currentTime)
          const remainTime = Math.ceil(diffInMilliseconds / (1000 * 60 * 60 * 24))
          this.money = remainTime * 1
          this.penaltyid = item.id
        })
      })
    }
  },
  data() {
    return {
      buttonType: 'success',
      buttonText: 'add to favorite',
      isBookFavorite: false,
      form: {},
      form2: {},
      form3: {},
      dialogVisible: false,
      dialogVisible2: false,
      search1: '',
      search2: '',
      search3: '',
      total: 10,
      currentPage: 1,
      pageSize: 10,
      tableData: [],
      user: {},
      number: 0,
      bookData: [],
      isbnArray: [],
      outDateBook: [],
      numOfOutDataBook: 0,
      dialogVisible3: true,
      dialogVisible4: false,
      currentBookId: null,
      money: 0,
      penaltyid: "",
      isbns: "",
      isbn: [],
      wrongAdd: []
    }
  },
}
</script>
<style>
.text-center{
  text-align: center;
}
</style>
