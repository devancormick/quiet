//
//  QuietTunnelBridgingHeader.h
//  QuietTunnel
//
//  Created by Johnny Lin on 4/12/22.
//  Copyright © 2022 Quiet Inc. All rights reserved.
//

#ifndef QuietTunnelBridgingHeader_h
#define QuietTunnelBridgingHeader_h

#import <resolv.h>
#import <stdlib.h>

// The iOS 18 SDK imports `struct __res_9_state` into Swift in a way the old
// call sites can't use: `__res_9_state()` no longer yields a struct value and
// `&state` ends up a pointer-to-optional-pointer, so the res_9_* calls won't
// compile. Keep the resolver state entirely in C — Swift only ever holds it as
// an opaque pointer — and expose plain functions over it. The tunnel's Resolver
// calls these instead of touching __res_9_state directly.

static inline struct __res_9_state *quiet_res_alloc(void) {
    struct __res_9_state *state = (struct __res_9_state *)calloc(1, sizeof(struct __res_9_state));
    if (state) {
        res_9_ninit(state);
    }
    return state;
}

static inline void quiet_res_free(struct __res_9_state *state) {
    if (state) {
        res_9_ndestroy(state);
        free(state);
    }
}

static inline int quiet_res_getservers(struct __res_9_state *state,
                                       union res_9_sockaddr_union *set,
                                       int cnt) {
    return res_9_getservers(state, set, cnt);
}

#endif /* QuietTunnelBridgingHeader_h */
