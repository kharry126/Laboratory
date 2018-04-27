class ExcelStore {
    constructor() {
        this.active = 0;
        this.maxIndex = 2;
        this.init();
        this.process = [];
    }

    init () {
        this.list = {
            'upload': '上传文件',
            'preview': '预览数据',
            'savetable': '保存'
        }
    }

    setProcess (processList) {
        this.process = [];
        if (processList) {
            for (var i in processList) {
                let key = processList[i];
                let item = this.list[key];
                if (item !== null && item !== '') {
                    this.process.push({
                        id: key,
                        title: item
                    })
                }
            }
        }
        console.info(this.process);
    }

    isShow (type) {
        let value = this.process.find((item) => {
           return item.id === type;
        });
        if (value) {
            return true;
        } else {
            return false;
        }
    }

    next() {
        this.active++;
        if (this.active > this.maxIndex) {
            this.active = 0;
        }
    }
    
    prev() {
        this.active--;
        if (this.active < 0) {
            this.active = 0;
        }
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
}

export default ExcelStore
