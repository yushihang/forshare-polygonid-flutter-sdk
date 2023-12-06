//
//  babyjubjub_with_exception_handing.m
//  babyjubjub_with_exception_handing
//
//  Created by yushihang on 2023/11/22.
//

#import "babyjubjub_with_exception_handing.h"
#include <iostream>

char *pack_signature_with_exception_handing(const char *signature) {
    try {
        return pack_signature(signature);
    } catch (...) {
        std::cout << "exception in: " << __func__ << std::endl;
        return nil;
    }
}

char *unpack_signature_with_exception_handing(const char *compressed_signature) {
    try {
        return unpack_signature(compressed_signature);
    } catch (...) {
        std::cout << "exception in: " << __func__ << std::endl;
        
        try{
            
        }
        catch (...) {
            
        }
        return nil;
    }
}

char *pack_point_with_exception_handing(const char *point_x, const char *point_y) {
    try {
        return pack_point(point_x, point_y);
    } catch (...) {
        std::cout << "exception in: " << __func__ << std::endl;
        return nil;
    }
}

char *unpack_point_with_exception_handing(const char *compressed_point) {
    try {
        return unpack_point(compressed_point);
    } catch (...) {
        std::cout << "exception in: " << __func__ << std::endl;
        return nil;
    }
}

char *prv2pub_with_exception_handing(const char *private_key){
    try {
        return prv2pub(private_key);
    } catch (...) {
        std::cout << "exception in: " << __func__ << std::endl;
        return nil;
    }
}

char *poseidon_hash_with_exception_handing(const char *input) {
    try {
        return poseidon_hash(input);
    } catch (...) {
        std::cout << "exception in: " << __func__ << std::endl;
        return nil;
    }
}

char *poseidon_hash2_with_exception_handing(const char *in1, const char *in2) {
    try {
        return poseidon_hash2(in1, in2);
    } catch (...) {
        std::cout << "exception in: " << __func__ << std::endl;
        return nil;
    }
}

char *poseidon_hash3_with_exception_handing(const char *in1, const char *in2, const char *in3) {
    try {
        return poseidon_hash3(in1, in2, in3);
    } catch (...) {
        std::cout << "exception in: " << __func__ << std::endl;
        return nil;
    }
}

char *poseidon_hash4_with_exception_handing(const char *in1, const char *in2, const char *in3, const char *in4) {
    try {
        return poseidon_hash4(in1, in2, in3, in4);
    } catch (...) {
        std::cout << "exception in: " << __func__ << std::endl;
        return nil;
    }
}

char *hash_poseidon_with_exception_handing(const char *claims_tree,
                                           const char *revocation_tree,
                                           const char *roots_tree_root){
    try {
        return hash_poseidon(claims_tree, revocation_tree, roots_tree_root);
    } catch (...) {
        std::cout << "exception in: " << __func__ << std::endl;
        return nil;
    }
    
}

char *sign_poseidon_with_exception_handing(const char *private_key, const char *msg) {
    try {
        return sign_poseidon(private_key, msg);
    } catch (...) {
        std::cout << "exception in: " << __func__ << std::endl;
        return nil;
    }
}

char *verify_poseidon_with_exception_handing(const char *private_key,
                                             const char *compressed_signature,
                                             const char *message)  {
    try {
        return verify_poseidon(private_key, compressed_signature, message);
    } catch (...) {
        std::cout << "exception in: " << __func__ << std::endl;
        return nil;
    }
}

void cstring_free_with_exception_handing(char *str)  {
    try {
        return cstring_free(str);
    } catch (...) {
        std::cout << "exception in: " << __func__ << std::endl;
        return;
    }
}
