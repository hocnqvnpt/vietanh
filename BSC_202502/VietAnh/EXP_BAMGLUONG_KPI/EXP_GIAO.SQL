
--===================================================FILE THỰC HIỆN =============================================================

---======================================================RUN====================================================================
                                            
        -- Gọi procedure cho tháng hiện tại
                BEGIN
                    ttkd_bsc.exp_bangluong_kpi_giao(TO_NUMBER(TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM')));
                END;
                /                
                select * from ttkd_bsc.BLkpi_giao_202409_yyyymmddhh24mi; --BLkpi_giao_202409_20241021_2310

---====================================================== BUILD ====================================================================
                           create or replace PROCEDURE ttkd_bsc.exp_bangluong_kpi_giao(
                                        p_thang    IN NUMBER    -- Tháng 
                                    ) AUTHID CURRENT_USER AS
                                        v_sql VARCHAR2(32767);
                                        v_query VARCHAR2(1000);
                                        v_ma_kpi ttkd_bsc.blkpi_danhmuc_kpi.ma_kpi%TYPE;
                                        v_CHITIEU_GIAO NUMBER;
                                        v_giao NUMBER;
                                        v_thuchien NUMBER;
                                        v_tyle_thuchien NUMBER;
                                        v_mucdo_hoanthanh NUMBER;
                                        v_diem_cong NUMBER;
                                        v_diem_tru NUMBER;
                                        cur_kpi SYS_REFCURSOR;  -- Khai báo con trỏ để xử lý truy vấn động
                                    BEGIN
--                                                 BEGIN
--                                                  EXECUTE IMMEDIATE 'DROP TABLE vietanhvh.BLkpi_' || p_thang ||'_giao';
--                                              EXCEPTION
--                                                  WHEN OTHERS THEN
--                                                      -- Bỏ qua lỗi nếu bảng không tồn tại
--                                                      IF SQLCODE != -942 THEN
--                                                          RAISE;
--                                                      END IF;
--                                              END;
                                        -- Tạo bảng mới với các cột KPI và các loại dữ liệu khác
                                        v_sql := 'CREATE TABLE ttkd_bsc.BLkpi_giao_' || p_thang ||'_'|| TO_CHAR(SYSDATE, 'yyyymmdd_hh24mi') || ' AS ' ||
                                                 'SELECT ma_nv, ten_nv, ma_vtcv, ten_vtcv, ma_to, ten_to, ma_pb, ten_pb, ';

                                        -- Truy vấn các KPI khác nhau theo thứ tự của các loại dữ liệu
                                        v_query := 'SELECT ma_kpi,CHITIEU_GIAO, giao, thuchien, tyle_thuchien, mucdo_hoanthanh, diem_cong, diem_tru ' ||
                                                   'FROM ttkd_bsc.blkpi_danhmuc_kpi WHERE thang = ' || p_thang || 
                                                   ' 
                                                   ORDER BY ma_kpi ASC';

                                        OPEN cur_kpi FOR v_query;

                                        -- Lặp qua từng hàng kết quả từ con trỏ
                                        LOOP
                                            FETCH cur_kpi INTO v_ma_kpi,v_CHITIEU_GIAO, v_giao, v_thuchien, v_tyle_thuchien, v_mucdo_hoanthanh, v_diem_cong, v_diem_tru;
                                            EXIT WHEN cur_kpi%NOTFOUND;

                                            -- Chỉ thêm cột vào bảng nếu giá trị tương ứng là 1
                                            IF v_giao = 1 THEN
                                                v_sql := v_sql || 'MAX(CASE WHEN ma_kpi = ''' || v_ma_kpi || ''' THEN GIAO END) AS "' || v_ma_kpi || '", ';
                                            END IF;
                                            ---
                                            IF v_CHITIEU_GIAO = 1 THEN
                                                v_sql := v_sql || 'MAX(CASE WHEN ma_kpi = ''' || v_ma_kpi || ''' THEN CHITIEU_GIAO END) AS "' || v_ma_kpi || '", ';
                                            END IF;

                                        END LOOP;

                                        CLOSE cur_kpi;

                                        -- Xóa dấu ',' cuối cùng và thêm câu lệnh GROUP BY
                                        v_sql := RTRIM(v_sql, ', ') || ' FROM ttkd_bsc.bangluong_kpi ' ||
                                                 'WHERE thang = ' || p_thang || ' ' || 
                                                 'GROUP BY ma_nv, ten_nv, ma_vtcv, ten_vtcv, ma_to, ten_to, ma_pb, ten_pb';

                                        -- In câu lệnh SQL để kiểm tra
                                        DBMS_OUTPUT.PUT_LINE(v_sql);
                                         -- In tên bảng vừa tạo: thanh công cụ View --> DBMS_output
                                      DBMS_OUTPUT.PUT_LINE('Created table: ' || v_table_name);

                                        -- Thực thi câu lệnh SQL để tạo bảng
                                        EXECUTE IMMEDIATE v_sql;

                                    EXCEPTION
                                        WHEN OTHERS THEN
                                            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
                                    END;
