//
//  Wrapper.hpp
//  GradingTest
//
//  Created by Leo on 2017/3/24.
//  Copyright © 2017年 DoSoMi. All rights reserved.
//


#ifndef Wrapper_hpp
#define Wrapper_hpp

struct _CString_ {
    char* basePtr;
    long length;
};

#ifdef __cplusplus
extern "C" {
#endif
    void* c_creatLeveldb(char* path);
    void c_closeLeveldb(void* leveldb);
    void c_leveldbSetValue(void* leveldb, struct _CString_ key, struct _CString_ value);
    struct _CString_ c_leveldbGetValue(void* leveldb, struct _CString_* key);
    struct _CString_* c_leveldbGetValues(void* leveldb, int offset);
    bool c_leveldbDeleteValue(void* leveldb, struct _CString_ key);
    int c_batchSize();
    
    void c_FreeCString(struct _CString_* string);
#ifdef __cplusplus
}
#endif

#endif /* Wrapper_hpp */
