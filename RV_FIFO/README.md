## Simulator
- Cadence Xcelium 25.03
- Options used: -access +rw -seed random -coverage functional

## Run
- ./run_xrun.sh rv_test random
- 選用 random_test (使用rv_seq, 隨機gatting 每筆資料)
- 選用 rv_d_* (direct test , 使用rv_d_seq, 每筆資料不gatting)
- scoreboard: 使用uvm_tlm_analysis_fifo 替代queue 作為reference model


## UVM 環境架構圖

```mermaid
flowchart TD
  subgraph uvm_test_top["uvm_test_top (test)"]
    subgraph rv_env["rv_env (env)"]
      subgraph rv_agt_in["rv_agt_in(agt_in)"]
        rv_sqr["rv_sqr (sqr)"]
        rv_drv_source["rv_drv_source (drv_source)"]
        rv_mon_in["rv_mon_in (mon_in)"]
      end
      subgraph rv_agt_out["rv_agt_out(agt_out)"]
        rv_drv_sink["rv_drv_sink (drv_sink)"]
        rv_mon_out["rv_mon_out (mon_out)"]
      end
      rv_subscriber["rv_subscriber (subscriber)"]
      rv_scb["rv_scb (scb)"]
    end
  end
```
## 訊號
```mermaid
flowchart LR
  %% Sequencer -> Drivers
  rv_sqr["sqr"] -->|txn| rv_drv_source["drv_source"]

  %% Drivers -> IF 
  rv_drv_source["drv_source"] -->|in_vld data_in| rv_if.drv["if_.drv"]
  rv_drv_sink   -->|out_rdy| rv_if.drv["if_.drv"]

  %% DUT block
  rv_if.drv --> RV_FIFO["rv_fifo"]
  RV_FIFO["rv_fifo"] --> rv_if.mon

  %% IF to mon
  rv_if.mon["if_.mon"]  --> |in_rdy in_vld data_in|rv_mon_in["mon_in"]
  rv_if.mon["if_.mon"]  --> |out_rdy out_vld data_out|rv_mon_out["mon_out"]

  %% MON to SCB
  rv_mon_in  -->|data_in| rv_scb["scb"]
  rv_mon_out -->|data_out| rv_scb["scb"]
  %% MON to SUBSCRIBER
  rv_mon_out  -->|out_rdy out_vld data_out| rv_subscriber["subscriber"]

```


## port connection 

```mermaid
flowchart LR
rv_sqr["sqr"] --> |seq_item_port|rv_drv_source["drv_source"]
rv_mon_in["mon_in"] -->|uvm_tlm_analysis_fifo|rv_scb["scb"]
rv_mon_out["mon_out"] -->|uvm_tlm_analysis_fifo.analysis_export|rv_scb["scb"]
rv_mon_out["mon_out"] -->|uvm_analysis_port.analysis_export|rv_subscriber["subscriber"]
```

