from typing import Dict

### PR IMPLEMENTATION

def _replace(mapping: Dict) -> Dict:
    old_ns = mapping
    loops = 0
    while loops < 5:  # don't recurse forever in case there's circular data
        ns = {k: old_ns[v] if v in old_ns else v for k, v in old_ns.items()}
        if old_ns == ns:
            break
        old_ns = ns
        loops += 1
    return ns

### MODIFIED PR IMPLEMENTATION

def _replace_mod(mapping: Dict) -> Dict:
    old_ns = mapping
    loops = 0
    while loops < 5:  # don't recurse forever in case there's circular data
        again = False
        ns = {}
        for k, v in old_ns.items():
            if v in old_ns:
                ns[k] = old_ns[v]
                if not again and ns[k] != v:
                    again = True
            else:
                ns[k] = v
        if not again:
            break
        old_ns = ns
        loops += 1
    return ns

### ALTERNATE PR IMPLEMENTATION

def _replace_alt(mapping: Dict) -> Dict:

    replace_list = []
    resolved_map = {}

    for key, val in mapping.items():

        if val not in mapping:
            resolved_map[key] = val
        elif val != key:
            replace_list.append((key,val))
        else:
            # cycle (self-referential)
            resolved_map[key] = val

    if not replace_list:

        mapping = resolved_map

    else:

        mapping = dict(mapping)

        for key, val in replace_list:

            if val in resolved_map:
                mapping[key] = resolved_map[val]
                continue

            replace_seen = set()
            replace_trail = [val]

            while val in mapping:

                nextval = mapping[val]
                if nextval in resolved_map:
                    val = resolved_map[nextval]
                    break

                replace_seen.add(val)
                if nextval in replace_seen:
                    # cycle detected
                    val = replace_trail[-1]
                    break

                replace_trail.append(nextval)
                val = nextval

            for resolved_key in replace_trail:
                resolved_map[resolved_key] = val

            mapping[key] = val

    return mapping

if __name__ == "__main__":

    import gc
    import platform
    import time

    TESTING = False
    TESTING_EXPS = [10, 20, 21]
    TESTING_GC = [False]

    NINVOCATIONS = pow(10, 7)  # exp >= 5 for elapsed time division

    ### TIMING

    def profile(func, mapping, ncalls=NINVOCATIONS, gcenabled=True):
        gc.collect()
        if not gcenabled:
            gc.disable()
        rval = None
        begtime = time.perf_counter()
        while ncalls > 0:
            ncalls -= 1
            rval = func(mapping)
        endtime = time.perf_counter()
        if not gcenabled:
            gc.enable()
        gc.collect()
        elapsed = endtime - begtime
        return rval, elapsed

    ### TESTING

    print(f"python version = {platform.python_version()!s}")
    print(f"number of invocations = {NINVOCATIONS:,}")
    for gcenabled in (True, False):

        if TESTING and TESTING_GC and gcenabled not in TESTING_GC:
            continue

        gcstatus = "Y" if gcenabled else "N"

        testnum = 0
        for CPPDEFINES, expect in [
            (
                #01 no replacements
                [("STRING1", "VALUE1"), ("STRING2", "VALUE2"), ("STRING3", "VALUE3")],
                {"STRING1": "VALUE1", "STRING2": "VALUE2", "STRING3": "VALUE3"},
            ),
            (
                #02 no replacements
                [("STRING1", "STRING1"), ("STRING2", "STRING2"), ("STRING3", "STRING3")],
                {"STRING1": "STRING1", "STRING2": "STRING2", "STRING3": "STRING3"},
            ),
            (
                #03 single replacement
                [("STRING", "VALUE"), ("REPLACEABLE", "RVALUE"), ("RVALUE", "AVALUE")],
                # Alternate algorithm replacement steps:
                #   [REPLACEABLE] RVALUE = AVALUE
                {"STRING": "VALUE", "REPLACEABLE": "AVALUE", "RVALUE": "AVALUE"},
            ),
            (
                #04 single replacement (first)
                [("AAA", "BBB"), ("BBB", "VALUE1"), ("CCC", "VALUE2"), ("DDD", "VALUE3"), ("EEE", "VALUE4"), ("FFF", "VALUE5")],
                # Alternate algorithm replacement steps:
                #   [AAA] BBB = VALUE1
                {"AAA": "VALUE1", "BBB": "VALUE1", "CCC": "VALUE2", "DDD": "VALUE3", "EEE": "VALUE4", "FFF": "VALUE5"},
            ),
            (
                #05 single replacement (last)
                [("AAA", "VALUE1"), ("BBB", "VALUE2"), ("CCC", "VALUE3"), ("DDD", "VALUE4"), ("EEE", "VALUE5"), ("FFF", "EEE")],
                # Alternate algorithm replacement steps:
                #   [FFF] EEE = VALUE5
                {"AAA": "VALUE1", "BBB": "VALUE2", "CCC": "VALUE3", "DDD": "VALUE4", "EEE": "VALUE5", "FFF": "VALUE5"},
            ),
            (
                #06 multiple replacements
                [("AAA", "XXX"), ("BBB", "YYY"), ("CCC", "VALUE1"), ("DDD", "VALUE2"), ("XXX", "DDD"), ("YYY", "CCC")],
                # Alternate algorithm replacement steps:
                #   [AAA] XXX = DDD = VALUE2
                #   [BBB] YYY = CCC = VALUE1
                #   [XXX] VALUE2
                #   [YYY] VALUE1
                {"AAA": "VALUE2", "BBB": "VALUE1", "CCC": "VALUE1", "DDD": "VALUE2", "XXX": "VALUE2", "YYY": "VALUE1"},
            ),
            (
                #07 multiple replacements
                [("AAA", "BBB"), ("BBB", "VALUE1"), ("CCC", "DDD"), ("DDD", "VALUE2"), ("EEE", "FFF"), ("FFF", "VALUE3")],
                # Alternate algorithm replacement steps:
                #   [AAA] BBB = VALUE1
                #   [CCC] DDD = VALUE2
                #   [EEE] FFF = VALUE3
                {"AAA": "VALUE1", "BBB": "VALUE1", "CCC": "VALUE2", "DDD": "VALUE2", "EEE": "VALUE3", "FFF": "VALUE3"},
            ),
            (
                #08 multiple replacements
                [("AAA", "BBB"), ("BBB", "VALUE1"), ("CCC", "AAA"), ("DDD", "BBB"), ("EEE", "AAA"), ("FFF", "BBB")],
                # Alternate algorithm replacement steps:
                #   [AAA] BBB = VALUE1
                #   [CCC] AAA = VALUE1
                #   [DDD] BBB = VALUE1
                #   [EEE] AAA = VALUE1
                #   [FFF] BBB = VALUE1
                {"AAA": "VALUE1", "BBB": "VALUE1", "CCC": "VALUE1", "DDD": "VALUE1", "EEE": "VALUE1", "FFF": "VALUE1"},
            ),
            (
                #09 long trail, single value
                [("A", "B"), ("B", "C"), ("C", "D"), ("D", "E"), ("E", "F"), ("F", "G"), ("G", "H"), ("H", "I"), ("I", "J"), ("J", "K"), ("K", "0")],
                # Algorithm replacement steps:
                #   [A] B = C = D = E = F = G = H = I = J = K = 0
                #   [B] 0
                #   ...
                #   [J] 0
                {"A": "0", "B": "0", "C": "0", "D": "0", "E": "0", "F": "0", "G": "0", "H": "0", "I": "0", "J": "0", "K": "0"},
            ),
            (
                #10 cycles
                [("ABC", "DEF"), ("DEF", "GHI"), ("GHI", "ABC"), ("XXX", "YYY"), ("YYY", "ZZZ"), ("ZZZ", "DEF")],
                # Algorithm replacement steps:
                #   [ABC] DEF = GHI = ABC
                #   [DEF] ABC
                #   [GHI] ABC
                #   [XXX] YYY = ZZZ = DEF = ABC
                #   [YYY] ABC
                #   [ZZZ] ABC
                {"ABC": "ABC", "DEF": "ABC", "GHI": "ABC", "XXX": "ABC", "YYY": "ABC", "ZZZ": "ABC"},
            ),
            (
                #11 none
                [("A", 0), ("B", 1), ("C", 2), ("D", 3), ("E", 4), ("F", 5), ("G", 6), ("H", 7)],
                {"A": 0, "B": 1, "C": 2, "D": 3, "E": 4, "F": 5, "G": 6, "H": 7},
            ),
            (
                #12 1 trail: best case
                [("A", 0), ("B", "A"), ("C", "B"), ("D", "C"), ("E", "D"), ("F", "E"), ("G", "F"), ("H", "G")],
                {"A": 0, "B": 0, "C": 0, "D": 0, "E": 0, "F": 0, "G": 0, "H": 0},
            ),
            (
                #13 2 trails: best case, worst case
                [("A", 0), ("B", "A"), ("C", "B"), ("D", "C"), ("E", "F"), ("F", "G"), ("G", "H"), ("H", 1)],
                {"A": 0, "B": 0, "C": 0, "D": 0, "E": 1, "F": 1, "G": 1, "H": 1},
            ),
            (
                #14 1 trail: worst case
                [("A", "B"), ("B", "C"), ("C", "D"), ("D", "E"), ("E", "F"), ("F", "G"), ("G", "H"), ("H", 0)],
                {"A": 0, "B": 0, "C": 0, "D": 0, "E": 0, "F": 0, "G": 0, "H": 0},
            ),
            (
                #15 none
                [("A", "0"), ("B", "1"), ("C", "2"), ("D", "3"), ("E", "4"), ("F", "5"), ("G", "6"), ("H", "7")],
                {"A": "0", "B": "1", "C": "2", "D": "3", "E": "4", "F": "5", "G": "6", "H": "7"},
            ),
            (
                #16 1 trail: best case
                [("A", "0"), ("B", "A"), ("C", "B"), ("D", "C"), ("E", "D"), ("F", "E"), ("G", "F"), ("H", "G")],
                {"A": "0", "B": "0", "C": "0", "D": "0", "E": "0", "F": "0", "G": "0", "H": "0"},
            ),
            (
                #17 2 trails: best case, worst case
                [("A", "0"), ("B", "A"), ("C", "B"), ("D", "C"), ("E", "F"), ("F", "G"), ("G", "H"), ("H", "1")],
                {"A": "0", "B": "0", "C": "0", "D": "0", "E": "1", "F": "1", "G": "1", "H": "1"},
            ),
            (
                #18 1 trail: worst case
                [("A", "B"), ("B", "C"), ("C", "D"), ("D", "E"), ("E", "F"), ("F", "G"), ("G", "H"), ("H", "0")],
                {"A": "0", "B": "0", "C": "0", "D": "0", "E": "0", "F": "0", "G": "0", "H": "0"},
            ),
            (
                #19 trail length = 33
                [
                    ("A0", "B0"), ("B0", "C0"), ("C0", "D0"), ("D0", "E0"), ("E0", "F0"), ("F0", "G0"), ("G0", "H0"), ("H0", "I0"), ("I0", "J0"), ("J0", "K0"),
                    ("K0", "L0"), ("L0", "M0"), ("M0", "N0"), ("N0", "O0"), ("O0", "P0"), ("P0", "Q0"), ("Q0", "R0"), ("R0", "S0"), ("S0", "T0"), ("T0", "U0"),
                    ("U0", "V0"), ("V0", "W0"), ("W0", "X0"), ("X0", "Y0"), ("Y0", "Z0"), ("Z0", "A1"), ("A1", "B1"), ("B1", "C1"), ("C1", "D1"), ("D1", "E1"),
                    ("E1", "F1"), ("F1", "G1"), ("G1", "2"),
                ],
                {   "A0": "2", "B0": "2", "C0": "2", "D0": "2", "E0": "2", "F0": "2", "G0": "2", "H0": "2", "I0": "2", "J0": "2",
                    "K0": "2", "L0": "2", "M0": "2", "N0": "2", "O0": "2", "P0": "2", "Q0": "2", "R0": "2", "S0": "2", "T0": "2",
                    "U0": "2", "V0": "2", "W0": "2", "X0": "2", "Y0": "2", "Z0": "2", "A1": "2", "B1": "2", "C1": "2", "D1": "2",
                    "E1": "2", "F1": "2", "G1": "2",
                },
            ),
            (
                #20: cycle
                [("A", "B"), ("B", "A")],

                {"A": "A", "B": "A"},
            ),
            (
                #21: cycle
                [("A", "B"), ("B", "C"), ("C", "A")],
                {"A": "A", "B": "A", "C": "A"},
            ),
        ]:
            testnum += 1
            if TESTING and TESTING_EXPS and testnum not in TESTING_EXPS:
                continue
            print("")
            mapping = {k: v for k, v in CPPDEFINES}

            print(f"{gcstatus} {testnum:02d} CPPDEFINES       {mapping}")

            rval_cur, elapsed_cur = profile(_replace, mapping, ncalls=NINVOCATIONS, gcenabled=gcenabled)
            status_cur = 'pass' if rval_cur == expect else 'FAIL'
            print(f"{gcstatus} {testnum:02d} cur {status_cur} {elapsed_cur:7.4f} {rval_cur}")

            rval_mod, elapsed_mod = profile(_replace_mod, mapping, ncalls=NINVOCATIONS, gcenabled=gcenabled)
            status_mod = 'pass' if rval_mod == expect else 'FAIL'
            print(f"{gcstatus} {testnum:02d} mod {status_mod} {elapsed_mod:7.4f} {rval_mod}")

            rval_alt, elapsed_alt = profile(_replace_alt, mapping, ncalls=NINVOCATIONS, gcenabled=gcenabled)
            status_alt = 'pass' if rval_alt == expect else 'FAIL'
            print(f"{gcstatus} {testnum:02d} alt {status_alt} {elapsed_alt:7.4f} {rval_alt}")
            
            rel = elapsed_mod / elapsed_cur
            which = "mod" if rel < 1.0 else "CUR"
            rel_error = ((elapsed_cur - elapsed_mod) / elapsed_mod) * 100.0
            delta = (elapsed_cur - elapsed_mod) / NINVOCATIONS
            print(f"{gcstatus} {testnum:02d} {which} ---- cur/mod {rel:7.4f} (rel_error = {rel_error:6.2f}% avg_delta = {delta:11.4E})")

            rel = elapsed_alt / elapsed_cur
            which = "alt" if rel < 1.0 else "CUR"
            rel_error = ((elapsed_cur - elapsed_alt) / elapsed_alt) * 100.0
            delta = (elapsed_cur - elapsed_alt) / NINVOCATIONS
            print(f"{gcstatus} {testnum:02d} {which} ---- cur/alt {rel:7.4f} (rel_error = {rel_error:6.2f}% avg_delta = {delta:11.4E})")

            rel = elapsed_alt / elapsed_mod
            which = "alt" if rel < 1.0 else "MOD"
            rel_error = ((elapsed_mod - elapsed_alt) / elapsed_alt) * 100.0
            delta = (elapsed_mod - elapsed_alt) / NINVOCATIONS
            print(f"{gcstatus} {testnum:02d} {which} ---- mod/alt {rel:7.4f} (rel_error = {rel_error:6.2f}% avg_delta = {delta:11.4E})")