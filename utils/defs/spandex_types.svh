`ifndef __SPANDEX_TYPES_SVH__
`define __SPANDEX_TYPES_SVH__

`include "spandex_consts.svh"

/*
 * Cache data types
 */
typedef logic[(`CPU_MSG_TYPE_WIDTH-1):0]	    cpu_msg_t; // CPU bus requests
typedef logic[(`COH_MSG_TYPE_WIDTH-1):0]	    coh_msg_t; // Requests without DMA, Forwards, Responses
typedef logic[(`MIX_MSG_TYPE_WIDTH-1):0]	    mix_msg_t; // Requests if including DMA
typedef logic[(`HSIZE_WIDTH-1):0]		        hsize_t;
typedef logic[(`HPROT_WIDTH-1):0]    	        hprot_t;
typedef logic[(`INVACK_CNT_WIDTH-1):0]	        invack_cnt_t;
typedef logic[(`INVACK_CNT_CALC_WIDTH-1):0]	    invack_cnt_calc_t;
typedef logic[(`ADDR_BITS-1):0]		            addr_t;
typedef logic[(`LINE_ADDR_BITS-1):0]		    line_addr_t;
typedef logic[(`L2_ADDR_BITS-1):0]              l2_addr_t;
typedef logic[(`LLC_ADDR_BITS-1):0]             llc_addr_t;
typedef logic[(`BITS_PER_WORD-1):0]		        word_t;
typedef logic signed[(`BITS_PER_WORD-1):0]		sword_t;
typedef logic[(`BITS_PER_LINE-1):0]	            line_t;
typedef logic[(`L2_TAG_BITS-1):0]		        l2_tag_t;
typedef logic[(`LLC_TAG_BITS-1):0]		        llc_tag_t;
typedef logic[(`L2_SET_BITS-1):0]		        l2_set_t;
typedef logic[(`LLC_SET_BITS-1):0]		        llc_set_t;
//@TODO
//`if (L2_WAY_BITS == 1)
//typedef logic[(2-1):0] l2_way_t;
//`else
typedef logic[(`L2_WAY_BITS-1):0]               l2_way_t;
//`endif
typedef logic[(`LLC_WAY_BITS-1):0]		        llc_way_t;
typedef logic[(`OFFSET_BITS-1):0]		        offset_t;
typedef logic[(`WORD_BITS-1):0]		            word_offset_t;
typedef logic[(`BYTE_BITS-1):0]		            byte_offset_t;
typedef logic[(`STABLE_STATE_BITS-1):0]	        state_t;
typedef logic[(`LLC_STATE_BITS-1):0]	        llc_state_t;
typedef logic[(`UNSTABLE_STATE_BITS-1):0]	    unstable_state_t;
typedef logic[(`LLC_UNSTABLE_STATE_BITS-1):0]	llc_unstable_state_t;
typedef logic[(`CACHE_ID_WIDTH-1):0]            cache_id_t;
typedef logic[(`LLC_COH_DEV_ID_WIDTH-1):0]      llc_coh_dev_id_t;
typedef logic[(`WORDS_PER_LINE-1):0]		    owner_t;
typedef logic[(`MAX_N_L2-1):0]		            sharers_t;
typedef logic[(`DMA_BURST_LENGTH_BITS-1):0]     dma_length_t;
typedef logic[(`BRESP_WIDTH-1):0]               bresp_t;
typedef logic[(`AMO_WIDTH-1):0]                 amo_t;
typedef logic[(`DCS_WIDTH-1):0]                 dcs_t;
typedef logic[(`WORDS_PER_LINE-1):0]            word_mask_t;
typedef logic[1:0]                              fence_t;
typedef logic[(`MAX_N_L2_BITS-1):0]		        num_l2_t;

// invalidate address
typedef line_addr_t l2_inval_addr_t;

// ongoing request buffer
typedef struct packed{
    cpu_msg_t           cpu_msg;
    l2_tag_t            tag;
    l2_set_t            set;
    l2_way_t            way;
    hsize_t             hsize;
    word_offset_t       w_off;
    byte_offset_t       b_off;
    unstable_state_t    state;
    hprot_t             hprot;
    word_t              word;
    line_t              line;
    amo_t               amo;
    word_mask_t         word_mask;
    word_mask_t         word_mask_reg;
} mshr_buf_t;

typedef struct packed{
    mix_msg_t               msg;
    cache_id_t              req_id;
    llc_tag_t               tag;
    llc_set_t               set;
    llc_way_t               way;
    llc_unstable_state_t    state;
    hprot_t                 hprot;
    invack_cnt_calc_t	    invack_cnt;
    line_t                  line;
    word_mask_t             word_mask;
    word_mask_t             word_mask_reg;
} mshr_llc_buf_t;

`endif // __SPANDEX_TYPES_SVH__