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

// The iOS 18 SDK imports the libresolv res_9_* functions into Swift with a
// pointer signature the old call sites can't satisfy (Swift sees a
// double-pointer and refuses to compile). These thin static-inline wrappers
// take an explicit `struct __res_9_state *`, so Swift imports them as plain
// (UnsafeMutablePointer<__res_9_state>) -> ... functions. The tunnel's Resolver
// calls these instead of the raw res_9_* symbols.

static inline int quiet_res_ninit(struct __res_9_state *state) {
    return res_9_ninit(state);
}

static inline void quiet_res_ndestroy(struct __res_9_state *state) {
    res_9_ndestroy(state);
}

static inline int quiet_res_getservers(struct __res_9_state *state,
                                       union res_9_sockaddr_union *set,
                                       int cnt) {
    return res_9_getservers(state, set, cnt);
}

#endif /* QuietTunnelBridgingHeader_h */
