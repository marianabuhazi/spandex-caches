`timescale 1ps / 1ps
`include "spandex_consts.svh"
`include "spandex_types.svh"

module l2_interfaces(
    input logic clk,
    input logic rst,
    input logic l2_cpu_req_valid,
    input logic l2_cpu_req_ready_int,
    input logic l2_fwd_in_valid,
    input logic l2_fwd_in_ready_int,
    input logic l2_rsp_in_valid,
    input logic l2_rsp_in_ready_int,
    input logic l2_flush_valid,
    input logic l2_flush_ready_int,
    input logic l2_flush_i,
    input logic l2_fence_valid,
    input logic l2_fence_ready_int,
    input fence_t l2_fence_i,
    input logic l2_req_out_valid_int,
    input logic l2_req_out_ready,
    input logic l2_rsp_out_valid_int,
    input logic l2_rsp_out_ready,
    input logic l2_fwd_out_valid_int,
    input logic l2_fwd_out_ready,
    input logic l2_rd_rsp_valid_int,
    input logic l2_rd_rsp_ready,
    input logic l2_inval_valid_int,
    input logic l2_inval_ready,
    input logic set_cpu_req_from_conflict,
    input logic set_cpu_req_conflict,
    input logic set_fwd_in_from_stalled,
    input logic set_fwd_in_stalled,
    input logic l2_bresp_ready,
    input logic l2_bresp_valid_int,
    input bresp_t l2_bresp_o,

    l2_cpu_req_t.in l2_cpu_req_i,
    l2_fwd_in_t.in l2_fwd_in_i,
    l2_rsp_in_t.in l2_rsp_in_i,
    l2_req_out_t.in l2_req_out_o,
    l2_rsp_out_t.in l2_rsp_out_o,
    l2_fwd_out_t.in l2_fwd_out_o,
    l2_rd_rsp_t.in l2_rd_rsp_o,
    l2_inval_t.in l2_inval_o,

    output logic l2_cpu_req_ready,
    output logic l2_cpu_req_valid_int,
    output logic l2_fwd_in_ready,
    output logic l2_fwd_in_valid_int,
    output logic l2_rsp_in_ready,
    output logic l2_rsp_in_valid_int,
    output logic l2_flush_ready,
    output logic l2_flush_valid_int,
    output logic l2_fence_ready,
    output logic l2_fence_valid_int,
    output logic l2_req_out_ready_int,
    output logic l2_req_out_valid,
    output logic l2_rsp_out_ready_int,
    output logic l2_rsp_out_valid,
    output logic l2_fwd_out_ready_int,
    output logic l2_fwd_out_valid,
    output logic l2_rd_rsp_ready_int,
    output logic l2_rd_rsp_valid,
    output logic l2_inval_ready_int,
    output logic l2_inval_valid,
    output logic is_flush_all,
    output logic l2_bresp_valid,
    output logic l2_bresp_ready_int,
    output bresp_t l2_bresp,
    output line_addr_t rsp_in_addr,
    output line_addr_t fwd_in_addr,
    output line_addr_t fwd_in_tmp_addr,
    output addr_t cpu_req_addr,
    output fence_t l2_fence,

    l2_req_out_t.out l2_req_out,
    l2_rsp_out_t.out l2_rsp_out,
    l2_fwd_out_t.out l2_fwd_out,
    l2_rd_rsp_t.out l2_rd_rsp,
    l2_cpu_req_t.out l2_cpu_req,
    l2_fwd_in_t.out l2_fwd_in,
    l2_rsp_in_t.out l2_rsp_in,
    l2_inval_t.out l2_inval
    );

    //L2 REQ IN
    logic l2_cpu_req_valid_tmp;
    l2_cpu_req_t l2_cpu_req_tmp();
    l2_cpu_req_t l2_cpu_req_next();

    interface_controller l2_cpu_req_intf(
        .clk(clk),
        .rst(rst),
        .ready_in(l2_cpu_req_ready_int),
        .valid_in(l2_cpu_req_valid),
        .ready_out(l2_cpu_req_ready),
        .valid_out(l2_cpu_req_valid_int),
        .valid_tmp(l2_cpu_req_valid_tmp)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_cpu_req_tmp.cpu_msg <= 0;
            l2_cpu_req_tmp.hsize <= 0;
            l2_cpu_req_tmp.hprot <= 0;
            l2_cpu_req_tmp.addr <= 0;
            l2_cpu_req_tmp.word <= 0;
            l2_cpu_req_tmp.amo <= 0;
            l2_cpu_req_tmp.aq <= 0;
            l2_cpu_req_tmp.rl <= 0;
            l2_cpu_req_tmp.dcs_en <= 0;
            l2_cpu_req_tmp.use_owner_pred <= 0;
            l2_cpu_req_tmp.dcs <= 0;
            l2_cpu_req_tmp.pred_cid <= 0;
        end else if (l2_cpu_req_valid && l2_cpu_req_ready && !l2_cpu_req_ready_int) begin
            l2_cpu_req_tmp.cpu_msg <= l2_cpu_req_i.cpu_msg;
            l2_cpu_req_tmp.hsize <= l2_cpu_req_i.hsize;
            l2_cpu_req_tmp.hprot <= l2_cpu_req_i.hprot;
            l2_cpu_req_tmp.addr <= l2_cpu_req_i.addr;
            l2_cpu_req_tmp.word <= l2_cpu_req_i.word;
            l2_cpu_req_tmp.amo <= l2_cpu_req_i.amo;
            l2_cpu_req_tmp.aq <= l2_cpu_req_i.aq;
            l2_cpu_req_tmp.rl <= l2_cpu_req_i.rl;
            l2_cpu_req_tmp.dcs_en <= l2_cpu_req_i.dcs_en;
            l2_cpu_req_tmp.use_owner_pred <= l2_cpu_req_i.use_owner_pred;
            l2_cpu_req_tmp.dcs <= l2_cpu_req_i.dcs;
            l2_cpu_req_tmp.pred_cid <= l2_cpu_req_i.pred_cid;
        end
    end

    assign l2_cpu_req_next.cpu_msg = (!l2_cpu_req_valid_tmp) ? l2_cpu_req_i.cpu_msg : l2_cpu_req_tmp.cpu_msg;
    assign l2_cpu_req_next.hsize = (!l2_cpu_req_valid_tmp) ? l2_cpu_req_i.hsize : l2_cpu_req_tmp.hsize;
    assign l2_cpu_req_next.hprot = (!l2_cpu_req_valid_tmp) ? l2_cpu_req_i.hprot : l2_cpu_req_tmp.hprot;
    assign l2_cpu_req_next.addr = (!l2_cpu_req_valid_tmp) ? l2_cpu_req_i.addr : l2_cpu_req_tmp.addr;
    assign l2_cpu_req_next.word = (!l2_cpu_req_valid_tmp) ? l2_cpu_req_i.word : l2_cpu_req_tmp.word;
    assign l2_cpu_req_next.amo = (!l2_cpu_req_valid_tmp) ? l2_cpu_req_i.amo : l2_cpu_req_tmp.amo;
    assign l2_cpu_req_next.aq = (!l2_cpu_req_valid_tmp) ? l2_cpu_req_i.aq : l2_cpu_req_tmp.aq;
    assign l2_cpu_req_next.rl = (!l2_cpu_req_valid_tmp) ? l2_cpu_req_i.rl : l2_cpu_req_tmp.rl;
    assign l2_cpu_req_next.dcs_en = (!l2_cpu_req_valid_tmp) ? l2_cpu_req_i.dcs_en : l2_cpu_req_tmp.dcs_en;
    assign l2_cpu_req_next.use_owner_pred = (!l2_cpu_req_valid_tmp) ? l2_cpu_req_i.use_owner_pred : l2_cpu_req_tmp.use_owner_pred;
    assign l2_cpu_req_next.dcs = (!l2_cpu_req_valid_tmp) ? l2_cpu_req_i.dcs : l2_cpu_req_tmp.dcs;
    assign l2_cpu_req_next.pred_cid = (!l2_cpu_req_valid_tmp) ? l2_cpu_req_i.pred_cid : l2_cpu_req_tmp.pred_cid;

    //L2 FWD IN
    logic l2_fwd_in_valid_tmp;
    l2_fwd_in_t l2_fwd_in_tmp();
    l2_fwd_in_t l2_fwd_in_next();

    interface_controller l2_fwd_in_intf(
        .clk(clk),
        .rst(rst),
        .ready_in(l2_fwd_in_ready_int),
        .valid_in(l2_fwd_in_valid),
        .ready_out(l2_fwd_in_ready),
        .valid_out(l2_fwd_in_valid_int),
        .valid_tmp(l2_fwd_in_valid_tmp)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_fwd_in_tmp.coh_msg <= 0;
            l2_fwd_in_tmp.addr <= 0;
            l2_fwd_in_tmp.req_id <= 0;
            l2_fwd_in_tmp.line <= 0;
            l2_fwd_in_tmp.word_mask <= 0;
        end else if (l2_fwd_in_valid && l2_fwd_in_ready && !l2_fwd_in_ready_int) begin
            l2_fwd_in_tmp.coh_msg <= l2_fwd_in_i.coh_msg;
            l2_fwd_in_tmp.addr <= l2_fwd_in_i.addr;
            l2_fwd_in_tmp.req_id <= l2_fwd_in_i.req_id;
            l2_fwd_in_tmp.line <= l2_fwd_in_i.line;
            l2_fwd_in_tmp.word_mask <= l2_fwd_in_i.word_mask;
        end
    end

    assign l2_fwd_in_next.coh_msg = (!l2_fwd_in_valid_tmp) ? l2_fwd_in_i.coh_msg : l2_fwd_in_tmp.coh_msg;
    assign l2_fwd_in_next.addr = (!l2_fwd_in_valid_tmp) ? l2_fwd_in_i.addr : l2_fwd_in_tmp.addr;
    assign l2_fwd_in_next.req_id = (!l2_fwd_in_valid_tmp) ? l2_fwd_in_i.req_id : l2_fwd_in_tmp.req_id;
    assign l2_fwd_in_next.line = (!l2_fwd_in_valid_tmp) ? l2_fwd_in_i.line : l2_fwd_in_tmp.line;
    assign l2_fwd_in_next.word_mask = (!l2_fwd_in_valid_tmp) ? l2_fwd_in_i.word_mask : l2_fwd_in_tmp.word_mask;

    //L2 RSP IN
    logic l2_rsp_in_valid_tmp;
    l2_rsp_in_t l2_rsp_in_tmp();
    l2_rsp_in_t l2_rsp_in_next();

    interface_controller l2_rsp_in_intf(
        .clk(clk),
        .rst(rst),
        .ready_in(l2_rsp_in_ready_int),
        .valid_in(l2_rsp_in_valid),
        .ready_out(l2_rsp_in_ready),
        .valid_out(l2_rsp_in_valid_int),
        .valid_tmp(l2_rsp_in_valid_tmp)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_rsp_in_tmp.coh_msg <= 0;
            l2_rsp_in_tmp.addr <= 0;
            l2_rsp_in_tmp.line <= 0;
            l2_rsp_in_tmp.word_mask <= 0;
            l2_rsp_in_tmp.invack_cnt <= 0;
        end else if (l2_rsp_in_valid && l2_rsp_in_ready && !l2_rsp_in_ready_int) begin
            l2_rsp_in_tmp.coh_msg <= l2_rsp_in_i.coh_msg;
            l2_rsp_in_tmp.addr <= l2_rsp_in_i.addr;
            l2_rsp_in_tmp.line <= l2_rsp_in_i.line;
            l2_rsp_in_tmp.word_mask <= l2_rsp_in_i.word_mask;
            l2_rsp_in_tmp.invack_cnt <= l2_rsp_in_i.invack_cnt;
        end
    end

    assign l2_rsp_in_next.coh_msg = (!l2_rsp_in_valid_tmp) ? l2_rsp_in_i.coh_msg : l2_rsp_in_tmp.coh_msg;
    assign l2_rsp_in_next.addr = (!l2_rsp_in_valid_tmp) ? l2_rsp_in_i.addr : l2_rsp_in_tmp.addr;
    assign l2_rsp_in_next.line = (!l2_rsp_in_valid_tmp) ? l2_rsp_in_i.line : l2_rsp_in_tmp.line;
    assign l2_rsp_in_next.word_mask = (!l2_rsp_in_valid_tmp) ? l2_rsp_in_i.word_mask : l2_rsp_in_tmp.word_mask;
    assign l2_rsp_in_next.invack_cnt = (!l2_rsp_in_valid_tmp) ? l2_rsp_in_i.invack_cnt : l2_rsp_in_tmp.invack_cnt;

    //L2 FLUSH
    logic l2_flush_valid_tmp, l2_flush_tmp, l2_flush_next;

    interface_controller l2_flush_intf(
        .clk(clk),
        .rst(rst),
        .ready_in(l2_flush_ready_int),
        .valid_in(l2_flush_valid),
        .ready_out(l2_flush_ready),
        .valid_out(l2_flush_valid_int),
        .valid_tmp(l2_flush_valid_tmp)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_flush_tmp <= 0;
        end else if (l2_flush_valid && l2_flush_ready && !l2_flush_ready_int) begin
            l2_flush_tmp <= l2_flush_i;
        end
    end

    assign l2_flush_next = (!l2_flush_valid_tmp) ? l2_flush_i : l2_flush_tmp;

    //L2 FENCE
    logic l2_fence_valid_tmp;
    fence_t l2_fence_tmp, l2_fence_next;

    interface_controller l2_fence_intf(
        .clk(clk),
        .rst(rst),
        .ready_in(l2_fence_ready_int),
        .valid_in(l2_fence_valid),
        .ready_out(l2_fence_ready),
        .valid_out(l2_fence_valid_int),
        .valid_tmp(l2_fence_valid_tmp)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_fence_tmp <= 0;
        end else if (l2_fence_valid && l2_fence_ready && !l2_fence_ready_int) begin
            l2_fence_tmp <= l2_fence_i;
        end
    end

    assign l2_fence_next = (!l2_fence_valid_tmp) ? l2_fence_i : l2_fence_tmp;

    //L2 REQ OUT
    logic l2_req_out_valid_tmp;
    l2_req_out_t l2_req_out_tmp();

    interface_controller l2_req_out_intf(
        .clk(clk),
        .rst(rst),
        .ready_in(l2_req_out_ready),
        .valid_in(l2_req_out_valid_int),
        .ready_out(l2_req_out_ready_int),
        .valid_out(l2_req_out_valid),
        .valid_tmp(l2_req_out_valid_tmp)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_req_out_tmp.coh_msg <= 0;
            l2_req_out_tmp.hprot <= 0;
            l2_req_out_tmp.addr <= 0;
            l2_req_out_tmp.line <= 0;
            l2_req_out_tmp.word_mask <= 0;
        end else if (l2_req_out_valid_int && l2_req_out_ready_int && !l2_req_out_ready) begin
            l2_req_out_tmp.coh_msg <= l2_req_out_o.coh_msg;
            l2_req_out_tmp.hprot <= l2_req_out_o.hprot;
            l2_req_out_tmp.addr <= l2_req_out_o.addr;
            l2_req_out_tmp.line <= l2_req_out_o.line;
            l2_req_out_tmp.word_mask <= l2_req_out_o.word_mask;
        end
    end

    assign l2_req_out.coh_msg = (!l2_req_out_valid_tmp) ? l2_req_out_o.coh_msg : l2_req_out_tmp.coh_msg;
    assign l2_req_out.hprot = (!l2_req_out_valid_tmp) ? l2_req_out_o.hprot : l2_req_out_tmp.hprot;
    assign l2_req_out.addr = (!l2_req_out_valid_tmp) ? l2_req_out_o.addr : l2_req_out_tmp.addr;
    assign l2_req_out.line = (!l2_req_out_valid_tmp) ? l2_req_out_o.line : l2_req_out_tmp.line;
    assign l2_req_out.word_mask = (!l2_req_out_valid_tmp) ? l2_req_out_o.word_mask : l2_req_out_tmp.word_mask;

    //L2 RSP OUT
    logic l2_rsp_out_valid_tmp;
    l2_rsp_out_t l2_rsp_out_tmp();

    interface_controller l2_rsp_out_intf(
        .clk(clk),
        .rst(rst),
        .ready_in(l2_rsp_out_ready),
        .valid_in(l2_rsp_out_valid_int),
        .ready_out(l2_rsp_out_ready_int),
        .valid_out(l2_rsp_out_valid),
        .valid_tmp(l2_rsp_out_valid_tmp)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_rsp_out_tmp.coh_msg <= 0;
            l2_rsp_out_tmp.req_id <= 0;
            l2_rsp_out_tmp.to_req <= 0;
            l2_rsp_out_tmp.addr <= 0;
            l2_rsp_out_tmp.line <= 0;
            l2_rsp_out_tmp.word_mask <= 0;
        end else if (l2_rsp_out_valid_int && l2_rsp_out_ready_int && !l2_rsp_out_ready) begin
            l2_rsp_out_tmp.coh_msg <= l2_rsp_out_o.coh_msg;
            l2_rsp_out_tmp.req_id <= l2_rsp_out_o.req_id;
            l2_rsp_out_tmp.to_req <= l2_rsp_out_o.to_req;
            l2_rsp_out_tmp.addr <= l2_rsp_out_o.addr;
            l2_rsp_out_tmp.line <= l2_rsp_out_o.line;
            l2_rsp_out_tmp.word_mask <= l2_rsp_out_o.word_mask;
        end
    end

    assign l2_rsp_out.coh_msg = (!l2_rsp_out_valid_tmp) ? l2_rsp_out_o.coh_msg : l2_rsp_out_tmp.coh_msg;
    assign l2_rsp_out.req_id = (!l2_rsp_out_valid_tmp) ? l2_rsp_out_o.req_id : l2_rsp_out_tmp.req_id;
    assign l2_rsp_out.to_req = (!l2_rsp_out_valid_tmp) ? l2_rsp_out_o.to_req : l2_rsp_out_tmp.to_req;
    assign l2_rsp_out.addr = (!l2_rsp_out_valid_tmp) ? l2_rsp_out_o.addr : l2_rsp_out_tmp.addr;
    assign l2_rsp_out.line = (!l2_rsp_out_valid_tmp) ? l2_rsp_out_o.line : l2_rsp_out_tmp.line;
    assign l2_rsp_out.word_mask = (!l2_rsp_out_valid_tmp) ? l2_rsp_out_o.word_mask : l2_rsp_out_tmp.word_mask;

    //L2 FWD OUT
    logic l2_fwd_out_valid_tmp;
    l2_fwd_out_t l2_fwd_out_tmp();

    interface_controller l2_fwd_out_intf(
        .clk(clk),
        .rst(rst),
        .ready_in(l2_fwd_out_ready),
        .valid_in(l2_fwd_out_valid_int),
        .ready_out(l2_fwd_out_ready_int),
        .valid_out(l2_fwd_out_valid),
        .valid_tmp(l2_fwd_out_valid_tmp)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_fwd_out_tmp.coh_msg <= 0;
            l2_fwd_out_tmp.req_id <= 0;
            l2_fwd_out_tmp.to_req <= 0;
            l2_fwd_out_tmp.addr <= 0;
            l2_fwd_out_tmp.line <= 0;
            l2_fwd_out_tmp.word_mask <= 0;
        end else if (l2_fwd_out_valid_int && l2_fwd_out_ready_int && !l2_fwd_out_ready) begin
            l2_fwd_out_tmp.coh_msg <= l2_fwd_out_o.coh_msg;
            l2_fwd_out_tmp.req_id <= l2_fwd_out_o.req_id;
            l2_fwd_out_tmp.to_req <= l2_fwd_out_o.to_req;
            l2_fwd_out_tmp.addr <= l2_fwd_out_o.addr;
            l2_fwd_out_tmp.line <= l2_fwd_out_o.line;
            l2_fwd_out_tmp.word_mask <= l2_fwd_out_o.word_mask;
        end
    end

    assign l2_fwd_out.coh_msg = (!l2_fwd_out_valid_tmp) ? l2_fwd_out_o.coh_msg : l2_fwd_out_tmp.coh_msg;
    assign l2_fwd_out.req_id = (!l2_fwd_out_valid_tmp) ? l2_fwd_out_o.req_id : l2_fwd_out_tmp.req_id;
    assign l2_fwd_out.to_req = (!l2_fwd_out_valid_tmp) ? l2_fwd_out_o.to_req : l2_fwd_out_tmp.to_req;
    assign l2_fwd_out.addr = (!l2_fwd_out_valid_tmp) ? l2_fwd_out_o.addr : l2_fwd_out_tmp.addr;
    assign l2_fwd_out.line = (!l2_fwd_out_valid_tmp) ? l2_fwd_out_o.line : l2_fwd_out_tmp.line;
    assign l2_fwd_out.word_mask = (!l2_fwd_out_valid_tmp) ? l2_fwd_out_o.word_mask : l2_fwd_out_tmp.word_mask;

    //L2 RD RSP
    logic l2_rd_rsp_valid_tmp;
    l2_rd_rsp_t l2_rd_rsp_tmp();

    interface_controller l2_rd_rsp_intf(
        .clk(clk),
        .rst(rst),
        .ready_in(l2_rd_rsp_ready),
        .valid_in(l2_rd_rsp_valid_int),
        .ready_out(l2_rd_rsp_ready_int),
        .valid_out(l2_rd_rsp_valid),
        .valid_tmp(l2_rd_rsp_valid_tmp)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_rd_rsp_tmp.line <= 0;
        end else if (l2_rd_rsp_valid_int && l2_rd_rsp_ready_int && !l2_rd_rsp_ready) begin
            l2_rd_rsp_tmp.line <= l2_rd_rsp_o.line;
        end
    end

    assign l2_rd_rsp.line = (!l2_rd_rsp_valid_tmp) ? l2_rd_rsp_o.line : l2_rd_rsp_tmp.line;

    //L2 INVAL
    logic l2_inval_valid_tmp;
    l2_inval_t l2_inval_tmp();

    interface_controller l2_inval_intf(
        .clk(clk),
        .rst(rst),
        .ready_in(l2_inval_ready),
        .valid_in(l2_inval_valid_int),
        .ready_out(l2_inval_ready_int),
        .valid_out(l2_inval_valid),
        .valid_tmp(l2_inval_valid_tmp)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_inval_tmp.addr <= 0;
            l2_inval_tmp.hprot <= 1'b0;
        end else if (l2_inval_valid_int && l2_inval_ready_int && !l2_inval_ready) begin
            l2_inval_tmp.addr <= l2_inval_o.addr;
            l2_inval_tmp.hprot <= l2_inval_o.hprot;
        end
    end

    assign l2_inval.addr = (!l2_inval_valid_tmp) ? l2_inval_o.addr : l2_inval_tmp.addr;
    assign l2_inval.hprot = (!l2_inval_valid_tmp) ? l2_inval_o.hprot : l2_inval_tmp.hprot;

    //L2 BRESP
    logic l2_bresp_valid_tmp;
    bresp_t l2_bresp_tmp;

    interface_controller l2_bresp_intf(
        .clk(clk),
        .rst(rst),
        .ready_in(l2_bresp_ready),
        .valid_in(l2_bresp_valid_int),
        .ready_out(l2_bresp_ready_int),
        .valid_out(l2_bresp_valid),
        .valid_tmp(l2_bresp_valid_tmp)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_bresp_tmp <= 0;
        end else if (l2_bresp_valid_int && l2_bresp_ready_int && !l2_bresp_ready) begin
            l2_bresp_tmp <= l2_bresp_o;
        end
    end

    assign l2_bresp = (!l2_bresp_valid_tmp) ? l2_bresp_o : l2_bresp_tmp;

    //READ FROM INPUT
    //cpu req + conflict
    l2_cpu_req_t l2_cpu_req_conflict ();
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_cpu_req.cpu_msg <= 0;
            l2_cpu_req.hsize <= 0;
            l2_cpu_req.hprot <= 0;
            l2_cpu_req.addr <= 0;
            l2_cpu_req.word <= 0;
            l2_cpu_req.amo <= 0;
            l2_cpu_req.aq <= 0;
            l2_cpu_req.rl <= 0;
            l2_cpu_req.dcs_en <= 0;
            l2_cpu_req.use_owner_pred <= 0;
            l2_cpu_req.dcs <= 0;
            l2_cpu_req.pred_cid <= 0;
        end else if (set_cpu_req_from_conflict) begin
            l2_cpu_req.cpu_msg <= l2_cpu_req_conflict.cpu_msg;
            l2_cpu_req.hsize <= l2_cpu_req_conflict.hsize;
            l2_cpu_req.hprot <= l2_cpu_req_conflict.hprot;
            l2_cpu_req.addr <= l2_cpu_req_conflict.addr;
            l2_cpu_req.word <= l2_cpu_req_conflict.word;
            l2_cpu_req.amo <= l2_cpu_req_conflict.amo;
            l2_cpu_req.aq <= l2_cpu_req_conflict.aq;
            l2_cpu_req.rl <= l2_cpu_req_conflict.rl;
            l2_cpu_req.dcs_en <= l2_cpu_req_conflict.dcs_en;
            l2_cpu_req.use_owner_pred <= l2_cpu_req_conflict.use_owner_pred;
            l2_cpu_req.dcs <= l2_cpu_req_conflict.dcs;
            l2_cpu_req.pred_cid <= l2_cpu_req_conflict.pred_cid;
        end else if (l2_cpu_req_valid_int && l2_cpu_req_ready_int) begin
            l2_cpu_req.cpu_msg <= l2_cpu_req_next.cpu_msg;
            l2_cpu_req.hsize <= l2_cpu_req_next.hsize;
            l2_cpu_req.hprot <= l2_cpu_req_next.hprot;
            l2_cpu_req.addr <= l2_cpu_req_next.addr;
            l2_cpu_req.word <= l2_cpu_req_next.word;
            l2_cpu_req.amo <= l2_cpu_req_next.amo;
            l2_cpu_req.aq <= l2_cpu_req_next.aq;
            l2_cpu_req.rl <= l2_cpu_req_next.rl;
            l2_cpu_req.dcs_en <= l2_cpu_req_next.dcs_en;
            l2_cpu_req.use_owner_pred <= l2_cpu_req_next.use_owner_pred;
            l2_cpu_req.dcs <= l2_cpu_req_next.dcs;
            l2_cpu_req.pred_cid <= l2_cpu_req_next.pred_cid;
        end
    end

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_cpu_req_conflict.cpu_msg <= 0;
            l2_cpu_req_conflict.hsize <= 0;
            l2_cpu_req_conflict.hprot <= 0;
            l2_cpu_req_conflict.addr <= 0;
            l2_cpu_req_conflict.word <= 0;
            l2_cpu_req_conflict.amo <= 0;
            l2_cpu_req_conflict.aq <= 0;
            l2_cpu_req_conflict.rl <= 0;
            l2_cpu_req_conflict.dcs_en <= 0;
            l2_cpu_req_conflict.use_owner_pred <= 0;
            l2_cpu_req_conflict.dcs <= 0;
            l2_cpu_req_conflict.pred_cid <= 0;
        end else if (set_cpu_req_conflict) begin
            l2_cpu_req_conflict.cpu_msg <= l2_cpu_req.cpu_msg;
            l2_cpu_req_conflict.hsize <= l2_cpu_req.hsize;
            l2_cpu_req_conflict.hprot <= l2_cpu_req.hprot;
            l2_cpu_req_conflict.addr <= l2_cpu_req.addr;
            l2_cpu_req_conflict.word <= l2_cpu_req.word;
            l2_cpu_req_conflict.amo <= l2_cpu_req.amo;
            l2_cpu_req_conflict.aq <= l2_cpu_req.aq;
            l2_cpu_req_conflict.rl <= l2_cpu_req.rl;
            l2_cpu_req_conflict.dcs_en <= l2_cpu_req.dcs_en;
            l2_cpu_req_conflict.use_owner_pred <= l2_cpu_req.use_owner_pred;
            l2_cpu_req_conflict.dcs <= l2_cpu_req.dcs;
            l2_cpu_req_conflict.pred_cid <= l2_cpu_req.pred_cid;
        end
    end

    //fwd in + stalled
    l2_fwd_in_t l2_fwd_in_stalled ();
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_fwd_in.coh_msg <= 0;
            l2_fwd_in.addr <= 0;
            l2_fwd_in.req_id <= 0;
            l2_fwd_in.line <= 0;
            l2_fwd_in.word_mask <= 0;
        end else if (set_fwd_in_from_stalled) begin
            l2_fwd_in.coh_msg <= l2_fwd_in_stalled.coh_msg;
            l2_fwd_in.addr <= l2_fwd_in_stalled.addr;
            l2_fwd_in.req_id <= l2_fwd_in_stalled.req_id;
            l2_fwd_in.line <= l2_fwd_in_stalled.line;
            l2_fwd_in.word_mask <= l2_fwd_in_stalled.word_mask;
        end else if (l2_fwd_in_valid_int && l2_fwd_in_ready_int) begin
            l2_fwd_in.coh_msg <= l2_fwd_in_next.coh_msg;
            l2_fwd_in.addr <= l2_fwd_in_next.addr;
            l2_fwd_in.req_id <= l2_fwd_in_next.req_id;
            l2_fwd_in.line <= l2_fwd_in_next.line;
            l2_fwd_in.word_mask <= l2_fwd_in_next.word_mask;
        end
    end

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_fwd_in_stalled.coh_msg <= 0;
            l2_fwd_in_stalled.addr <= 0;
            l2_fwd_in_stalled.req_id <= 0;
            l2_fwd_in_stalled.line <= 0;
            l2_fwd_in_stalled.word_mask <= 0;
        end else if (set_fwd_in_stalled) begin
            l2_fwd_in_stalled.coh_msg <= l2_fwd_in.coh_msg;
            l2_fwd_in_stalled.addr <= l2_fwd_in.addr;
            l2_fwd_in_stalled.req_id <= l2_fwd_in.req_id;
            l2_fwd_in_stalled.line <= l2_fwd_in.line;
            l2_fwd_in_stalled.word_mask <= l2_fwd_in.word_mask;
        end
    end

    //rsp in
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_rsp_in.coh_msg <= 0;
            l2_rsp_in.addr <= 0;
            l2_rsp_in.line <= 0;
            l2_rsp_in.word_mask <= 0;
            l2_rsp_in.invack_cnt <= 0;
        end else if (l2_rsp_in_valid_int && l2_rsp_in_ready_int) begin
            l2_rsp_in.coh_msg <= l2_rsp_in_next.coh_msg;
            l2_rsp_in.addr <= l2_rsp_in_next.addr;
            l2_rsp_in.line <= l2_rsp_in_next.line;
            l2_rsp_in.word_mask <= l2_rsp_in_next.word_mask;
            l2_rsp_in.invack_cnt <= l2_rsp_in_next.invack_cnt;
        end
    end

    //flush
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            is_flush_all <= 1'b1;
        end else if (l2_flush_valid_int && l2_flush_ready_int) begin
            is_flush_all <= l2_flush_next;
        end
    end

    // fence
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            l2_fence <= 'h0;
        end else if (l2_fence_valid_int && l2_fence_ready_int) begin
            l2_fence <= l2_fence_next;
        end
    end

    assign rsp_in_addr = l2_rsp_in_valid_tmp ? l2_rsp_in_tmp.addr : l2_rsp_in_i.addr;
    assign fwd_in_addr = set_fwd_in_from_stalled ? l2_fwd_in_stalled.addr :
                            (l2_fwd_in_valid_tmp ? l2_fwd_in_tmp.addr : l2_fwd_in_i.addr);
    assign fwd_in_tmp_addr = l2_fwd_in_valid_tmp ? l2_fwd_in_tmp.addr : l2_fwd_in_i.addr;
    assign cpu_req_addr = set_cpu_req_from_conflict ? l2_cpu_req_conflict.addr :
                            (l2_cpu_req_valid_tmp ? l2_cpu_req_tmp.addr : l2_cpu_req_i.addr);
endmodule