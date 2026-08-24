// https://developer.arm.com/documentation/ddi0601/2025-09/AArch64-Registers/ID-AA64MMFR0-EL1--AArch64-Memory-Model-Feature-Register-0
// the EL 1 access is only in kernel mode. this code fake the register via hwcap
// https://docs.kernel.org/arch/arm64/cpu-feature-registers.html

// try this kernel module to get the actual register value
// https://github.com/lelegard/arm-cpusysregs

#include <asm/hwcap.h>
#include <stdio.h>
#include <sys/auxv.h>

#define get_cpu_ftr(id) ({                                    \
              unsigned long __val;                            \
              asm("mrs %0, "#id : "=r" (__val));              \
              printf("%-20s: 0x%016lx\n", #id, __val);        \
      })

int main(void)
{

      if (!(getauxval(AT_HWCAP) & HWCAP_CPUID)) {
              fputs("CPUID registers unavailable\n", stderr);
              return 1;
      }

      get_cpu_ftr(ID_AA64ISAR0_EL1);
      get_cpu_ftr(ID_AA64ISAR1_EL1);
      get_cpu_ftr(ID_AA64MMFR0_EL1);
      get_cpu_ftr(ID_AA64MMFR1_EL1);
      get_cpu_ftr(ID_AA64PFR0_EL1);
      get_cpu_ftr(ID_AA64PFR1_EL1);
      get_cpu_ftr(ID_AA64DFR0_EL1);
      get_cpu_ftr(ID_AA64DFR1_EL1);

      get_cpu_ftr(MIDR_EL1);
      get_cpu_ftr(MPIDR_EL1);
      get_cpu_ftr(REVIDR_EL1);

#if 0
      /* Unexposed register access causes SIGILL */
      get_cpu_ftr(ID_MMFR0_EL1);
#endif

      return 0;
}