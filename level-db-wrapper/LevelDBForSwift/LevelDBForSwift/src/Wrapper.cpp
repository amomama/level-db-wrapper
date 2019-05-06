//
//  Wrapper.cpp
//  GradingTest
//
//  Created by Leo on 2017/3/24.
//  Copyright © 2017年 DoSoMi. All rights reserved.
//

#include "Wrapper.hpp"
#include "db.h"

#define MAX_BATCH_SIZE 10

void* c_creatLeveldb(char* path) // wrapper function
{
    leveldb::DB *_db;
    leveldb::Options options;
    options.create_if_missing = true;
    std::string string = path;
    leveldb::DB::Open(options, string, &_db);
    
    return _db;
}

void c_closeLeveldb(void* leveldb)
{
    leveldb::DB *_db = (leveldb::DB *)leveldb;
    if (_db) {
        delete _db;
        leveldb = NULL;
    }
}


void c_leveldbSetValue(void* leveldb, _CString_ key, _CString_ value)
{
    leveldb::Slice keySlice = leveldb::Slice(key.basePtr, key.length);
    leveldb::Slice valueSlice = leveldb::Slice(value.basePtr, value.length);
    leveldb::DB *_db = (leveldb::DB *)leveldb;
    leveldb::WriteOptions writeOption;
    leveldb::Status status = _db->Put(writeOption, keySlice, valueSlice);
    if (status.ok() != true) {
        printf("%s:%d c_leveldbSetValue error", __FILE__, __LINE__);
    }
}

_CString_ c_leveldbGetValue(void* leveldb, char* str, long length)
{
    leveldb::Slice keySlice = leveldb::Slice(str, length);
    std::string valueString;
    leveldb::DB *_db = (leveldb::DB *)leveldb;
    leveldb::ReadOptions readOptions;
    leveldb::Status status = _db->Get(readOptions, keySlice, &valueString);
    if (!status.ok()) {
        printf("%s:%d c_leveldbGetValue error", __FILE__, __LINE__);
    }
    long size = valueString.size();
    _CString_ result;
    result.basePtr = NULL;
    result.length = 0;
    
    if (size > 0) {
        char* p = (char*)malloc(size * sizeof(char));
        std::strcpy(p, valueString.c_str());
        result.basePtr = p;
        result.length = size;
    }
    return result;
}

_CString_* c_leveldbGetValues(void* leveldb, int offset)
{
    static _CString_ items[MAX_BATCH_SIZE];
    
    for (int i = 0; i < c_batchSize(); i++) {
        items[i] = _CString_{NULL, 0};
    }
    
    leveldb::DB *_db = (leveldb::DB *)leveldb;
    leveldb::Iterator *it = _db->NewIterator(leveldb::ReadOptions());
    
    int itemCounter = 0;
    int offsetCounter = 0;
    for (it->SeekToFirst(); it->Valid(); it->Next()) {
        if (offsetCounter < offset) {
            offsetCounter += 1;
            continue;
        }
        
        if (itemCounter >= c_batchSize()) {
            break;
        }
        
        std::string keyString = it->key().ToString();
        long size = keyString.size();
        _CString_ result = _CString_{ NULL, 0 };
        
        if (size > 0) {
            char* p = (char*)malloc(size * sizeof(char));
            std::strcpy(p, keyString.c_str());
            result.basePtr = p;
            result.length = size;
            itemCounter += 1;
        }
        items[itemCounter] = result;
    }
    
    assert(it->status().ok());
    delete it;
    
    return items;
}

bool c_leveldbDeleteValue(void* leveldb, struct _CString_ key)
{
    leveldb::Slice keySlice = leveldb::Slice(key.basePtr, key.length);
    leveldb::DB *_db = (leveldb::DB *)leveldb;
    leveldb::WriteOptions writeOption;
    leveldb::Status status = _db->Delete(writeOption, keySlice);
    if (!status.ok()) {
        printf("%s:%d c_leveldbDeleteValue error", __FILE__, __LINE__);
    }
    return status.ok();
}

void c_FreeCString(struct _CString_* string)
{
    if (string->basePtr) {
        delete string->basePtr;
        string->basePtr = NULL;
    }
}

void c_FreeCStringArray(struct _CString_* array) {
    for (int i = 0; i < c_batchSize(); i++) {
        _CString_ item = array[i];
        c_FreeCString(&item);
    }
}

int c_batchSize() {
    return MAX_BATCH_SIZE;
}
