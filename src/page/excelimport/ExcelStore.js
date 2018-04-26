class ExcelStore {
    constructor() {
        this.active = 2;
        this.maxIndex = 2;
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
