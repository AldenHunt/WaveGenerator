/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/ise/ise_projects/Thesis/fourblock.v";



static void Always_51_0(char *t0)
{
    char t7[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;

LAB0:    t1 = (t0 + 3320U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(51, ng0);
    t2 = (t0 + 3640);
    *((int *)t2) = 1;
    t3 = (t0 + 3352);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(51, ng0);

LAB5:    xsi_set_current_line(52, ng0);
    t4 = (t0 + 1848U);
    t5 = *((char **)t4);
    t4 = (t0 + 2008U);
    t6 = *((char **)t4);
    memset(t7, 0, 8);
    xsi_vlog_signed_add(t7, 16, t5, 16, t6, 16);
    t4 = (t0 + 2408);
    xsi_vlogvar_assign_value(t4, t7, 0, 0, 16);
    goto LAB2;

}


extern void work_m_17638916642629626839_0932368155_init()
{
	static char *pe[] = {(void *)Always_51_0};
	xsi_register_didat("work_m_17638916642629626839_0932368155", "isim/sixtyfourblock_tb_isim_beh.exe.sim/work/m_17638916642629626839_0932368155.didat");
	xsi_register_executes(pe);
}