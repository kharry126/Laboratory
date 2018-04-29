class ExcelStore {
    constructor(option) {
        this.active = 0;
        this.maxIndex = 2;
        this.init();
        this.setProcess(option.processList);
        this.success = option.success;
    }

    init () {
        this.list = {
            'upload': {
                title: '上传文件',
                footer: false
            },
            'preview': {
                title: '预览数据'
            },
            'savetable': {
                title: '保存'
            }
        }
    }

    setProcess (processList) {
        this.process = [];
        if (processList) {
            for (let i in processList) {
                let key = processList[i];
                let item = this.list[key];
                if (item) {
                    this.process.push({
                        id: key,
                        title: item.title,
                        footer: item.footer
                    })
                }
            }
        }
    }

    isShow (type) {
        let active = this.active;
        let value = this.process.find((item, index) => {
           return item.id === type && index === active;
        });
        if (value) {
            return true;
        } else {
            return false;
        }
    }

    next(type) {
        if (type) {
            let item = this.process[this.active];
            if (item && item.id === type) {
                this.active++;
                if (this.active > this.maxIndex) {
                    this.active = 0;
                }
            }
        } else {
            this.active++;
            if (this.active > this.maxIndex) {
                this.active = 0;
            }
        }
    }
    
    prev() {
        this.active--;
        if (this.active < 0) {
            this.active = 0;
        }
    }

    finish() {
        if (this.success) {
            this.success(this);
        }
    }

    getSheets () {
        let sheets =  [{
                name: 'Sheet1',
                id: 'tab1'
            }, {
                name: 'Sheet2',
                id: 'tab2'
            }, {
                name: 'Sheet3',
                id: 'tab3',
                empty: true
             }, {
                name: 'Sheet4',
                id: 'tab4',
                empty: true
            }, {
                name: 'Sheet5',
                id: 'tab5'
            }, {
                name: 'Sheet6',
                id: 'tab6',
                empty: true
            }, {
                name: 'Sheet7',
                id: 'tab7',
                empty: true
            }, {
                name: 'Sheet8',
                id: 'tab8'
            }]
        return sheets;
    }
    
    isUpload() {
        if (this.active === 0) {
            return true;
        }
        return false;
    }
    
    isPreview() {
        if (this.active === 1) {
            return true;
        }
        return false;
    }

    isSave() {
        if (this.active === 2) {
            return true;
        }
        return false
    }

    isActive (type) {
        let item = this.process[this.active];
        if (item.id === type) {
            return true;
        }
        return false;
    }

    isFinish () {
        if (this.active === (this.process.length - 1)) {
            return true;
        }
        return false;
    }

    isShowFooter () {
        let item = this.process[this.active];
        if (item.footer === false) {
            return false;
        }
        return true;
    }

    setFileName (resource, fileInfo) {
        this.fileName = resource;
        this.fileInfo = fileInfo;
    }

    loadPreviewData () {
        this.tabs || this.buildTabs();
        this.tableDatas || this.buildDatas();
        return {
            tabs: this.tabs,
            tableHeads: this.tableHeads,
            tableDatas: this.tableDatas
        };
    }

    buildTabs () {
        this.tabs = [{
            name: '工作表-Sheet1',
            id: 'tab1'
        }, {
            name: '工作表-Sheet2',
            id: 'tab2'
        }, {
            name: '工作表-Sheet3',
            id: 'tab3'
        }];
    }

    buildDatas () {
        this.tableHeads = {};
        this.tableDatas = {};
        for (let i in this.tabs) {
            let tab = this.tabs[i];
            this.tableHeads[tab.id] = [{
                name: 'temp1',
                label: '序号'
            }, {
                name: 'temp2',
                label: '姓名',
            }, {
                name: 'temp3',
                label: '编号',
            }]
            let data = [];
            for (let j = 0; j < 100; j++) {
                data.push({
                    temp1: j,
                    temp2: '张三' + tab.id,
                    temp3: '001002' + i
                })
            }
            this.tableDatas[tab.id] = data;   
        }
    }
}

export default ExcelStore
