# net name = [I/O]_[STAGE]_[TYPE]_[SIGNAME]
GLOBAL = ['clk', 'nrst']
STAGE = ['IF', 'IF_ID_Reg', 'ID', 'ID_EX_Reg', 'EX', 'EX_MEM_Reg', 'MEM', 'MEM_WB_Reg', 'WB']
TYPE = ['data', 'ctrl', 'mem', 'reg']

Signal = [
    ('PCNext',      'IF', 'EX',     'data', 32),
    ('instruction', 'IF', 'ID',     'data', 32),
    ('RSData',      'ID', 'EX',     'data', 32),
    ('RTData',      'ID', 'MEM',    'data', 32),
    ('RTAddr',      'ID', 'EX',     'data', 5),
    ('RDAddr',      'ID', 'EX',     'data', 5),
    ('AddrOffset',  'ID', 'EX',     'data', 32),
    ('Shamt',       'ID', 'EX',     'data', 5),
    ('Funct',       'ID', 'EX',     'data', 6),
    ('ALUOp',       'ID', 'EX',     'ctrl', 4),
    ('ALUSrc',      'ID', 'EX',     'ctrl', 1),
    ('RegDst',      'ID', 'EX',     'ctrl', 1),
    ('MemWrite',    'ID', 'MEM',    'ctrl', 1),
    ('MemRead',     'ID', 'MEM',    'ctrl', 1),
    ('Branch',      'ID', 'MEM',    'ctrl', 1),
    ('Mem2Reg',     'ID', 'WB',     'ctrl', 1),
    ('RegWrite',    'ID', 'WB',     'ctrl', 1),
    ('PCBranch',    'EX', 'MEM',    'data', 32),
    ('ALUOut',      'EX', 'MEM',    'data', 32),
    ('Zero',        'EX', 'MEM',    'data', 1),
    ('Overflow',    'EX', 'MEM',    'data', 1),
    ('RegAddrW',    'EX', 'WB',     'data', 32),
    ('MemData',     'MEM','WB',     'data', 32),
    ('ALUData',     'MEM','WB',     'data', 32)
]

Signal_Next = [
    ('PCSrc',       'MEM','IF',     'ctrl', 1),
    ('PCBranch',    'MEM','IF',     'data', 32),
]

Signal_External = [
    ('RegAddr1',    'ID', 'o',      'reg', 5),
    ('RegAddr2',    'ID', 'o',      'reg', 5),
    ('RegData1',    'ID', 'i',      'reg', 32),
    ('RegData2',    'ID', 'i',      'reg', 32),
    ('RegAddrW',    'WB', 'o',      'reg', 32),
    ('RegDataW',    'WB', 'o',      'reg', 32),
    ('RegWrite',    'WB', 'o',      'reg', 1),
    ('ImemAddr',    'IF', 'o',      'mem', 32),
    ('ImemDataR',   'IF', 'i',      'mem', 32),
    ('DmemAddr',    'MEM','o',      'mem', 32),
    ('DmemDataW',   'MEM','o',      'mem', 32),
    ('DmemDataR',   'MEM','i',      'mem', 32),
    ('MemRead',     'MEM','o',      'mem', 1),
    ('MemWrite',    'MEM','o',      'mem', 1)
]


def GenStage(fgen):

    for i, stage in enumerate(STAGE):
        header = {'input': [], 'output': [], 'bypass': []}
        content = {'assign': [], 'clk': [], 'rst': []}

        for sig in Signal:
            sname, start, end, stype, width = sig
            sname_i = f'i_{end}_{stype}_{sname}'
            sname_o = f'o_{end}_{stype}_{sname}'
            if width == 1:
                swidth = '\t'
            else:
                swidth = f'[{width-1}:0]'

            if start == stage:
                header['output'].append(f'output\twire\t{swidth}\t{sname_o}')
            elif end == stage:
                header['input'].append(f'input\twire\t{swidth}\t{sname_i}')
            elif STAGE.index(start) < i and STAGE.index(end) > i:
                header['bypass'].append(f'input\twire\t{swidth}\t{sname_i}')
                header['bypass'].append(f'output\twire\t{swidth}\t{sname_o}')
                if stage.find('_Reg') == -1:
                    content['assign'].append(f'assign {sname_o} = {sname_i};')
                else:
                    content['clk'].append(f'{sname_o} <= {sname_i};')
                    content['rst'].append(f'{sname_o} <= {width}\'d0;')
    
        for sig in Signal_Next:
            sname, start, end, stype, swidth = sig
            sname_i = f'i_{end}_{stype}_{sname}'
            sname_o = f'o_{end}_{stype}_{sname}'
            if swidth == 1:
                swidth = '\t'
            else:
                swidth = f'[{swidth-1}:0]'

            if start == stage:
                header['output'].append(f'output\twire\t{swidth}\t{sname_o}')
            elif end == stage:
                header['input'].append(f'input\twire\t{swidth}\t{sname_i}')
        
        for sig in Signal_External:
            sname, where, io, stype, swidth = sig
            sname_i = f'i_{where}_{stype}_{sname}'
            sname_o = f'o_{where}_{stype}_{sname}'
            if swidth == 1:
                swidth = '\t'
            else:
                swidth = f'[{swidth-1}:0]'

            if where == stage:
                if io == 'i':
                    header['input'].append(f'input\twire\t{swidth}\t{sname_i}')
                else:
                    header['output'].append(f'output\twire\t{swidth}\t{sname_o}')

        gen_input = '\t/* --- input --- */\n\t' + ',\n\t'.join(header['input'])
        gen_output = '\t/* --- output --- */\n\t' + ',\n\t'.join(header['output'])
        gen_bypass = '\t/* --- bypass --- */\n\t' + ',\n\t'.join(header['bypass'])
        has_input = len(header['input']) > 0
        has_output = len(header['output']) > 0
        has_bypass = len(header['bypass']) > 0
        
        gen_header = '\t/* --- global ---*/\n'
        for g in GLOBAL:
            gen_header += f'\tinput\twire\t{g},\n'

        gen_header += gen_input
        if has_input and (has_output or has_bypass):
            gen_header += ','
        gen_header += '\n' + gen_output
        if has_output and has_bypass:
            gen_header += ','
        gen_header += '\n' + gen_bypass
        
        fgen.write(
            f'module {stage}(\n'
            f'{gen_header}\n'
            f');\n\n'
        )

        if stage.find('_Reg') == -1:
            if len(header['output']) > 0:
                fgen.write('\t/* Output Assignment Begin */\n')
                for c in header['output']:
                    c = c.split('\t')[-1]
                    fgen.write(f'\tassign {c} = ;\n')
                fgen.write('\t/* Output Assignment End */\n')
            if len(content['assign']) > 0:
                fgen.write('\n\t/* Bypass Assignment Begin */\n')
                for c in content['assign']:
                    fgen.write(f'\t{c}\n')
                fgen.write('\t/* Bypass Assignment End */\n')
        else:
            gen_rst = '\n\t\t\t'.join(content['rst'])
            gen_clk = '\n\t\t\t'.join(content['clk'])
            fgen.write(
                f'\talways @ (posedge clk or negedge nrst) begin\n'
                f'\t\tif (~nrst) begin\n'
                f'\t\t\t{gen_rst}\n'
                f'\t\tend\n'
                f'\t\telse begin\n'
                f'\t\t\t{gen_clk}\n'
                f'\t\tend\n'
                f'\tend\n'
            )

        fgen.write('\nendmodule\n\n\n')
        fgen.flush()


def GenTop(fgen):

    content = []

    for i, stage in enumerate(STAGE):
        header = {'input': [], 'output': [], 'bypass': []}

        for sig in Signal:
            sname, start, end, stype, width = sig
            sname_i = f'i_{end}_{stype}_{sname}'
            sname_o = f'o_{end}_{stype}_{sname}'
            if width == 1:
                swidth = '\t'
            else:
                swidth = f'[{width-1}:0]'

            if stage.find('_Reg') == -1:
                wname_i = f'{stage}_{sname}_i'
                wname_o = f'{stage}_{sname}_o'
            else:
                prev_stage = stage.split('_')[0]
                next_stage = stage.split('_')[1]
                wname_i = f'{prev_stage}_{sname}_o'
                wname_o = f'{next_stage}_{sname}_i'

            if start == stage:
                header['output'].append((sname_o, wname_o, swidth))
                content.append(f'wire\t{swidth}\t{wname_o};')
            elif end == stage:
                header['input'].append((sname_i, wname_i, swidth))
                content.append(f'wire\t{swidth}\t{wname_i};')
            elif STAGE.index(start) < i and STAGE.index(end) > i:
                header['bypass'].append((sname_i, wname_i, swidth))
                header['bypass'].append((sname_o, wname_o, swidth))
                if stage.find('_Reg') == -1:
                    content.append(f'wire\t{swidth}\t{wname_i};')
                    content.append(f'wire\t{swidth}\t{wname_o};')
    
        for sig in Signal_Next:
            sname, start, end, stype, swidth = sig
            sname_i = f'i_{end}_{stype}_{sname}'
            sname_o = f'o_{end}_{stype}_{sname}'
            wname_i = f'{stage}_{sname}_i'
            wname_o = f'{stage}_{sname}_o'
            if swidth == 1:
                swidth = '\t'
            else:
                swidth = f'[{swidth-1}:0]'

            if start == stage:
                header['output'].append((sname_o, wname_o, swidth))
                content.append(f'wire\t{swidth}\t{wname_o};')
            elif end == stage:
                header['input'].append((sname_i, wname_i, swidth))
                content.append(f'wire\t{swidth}\t{wname_i}; assign {wname_i} = {start}_{sname}_o;')

        if stage.find('_Reg') == -1:
            content.append(f'// {stage} external signal (connected to Memory or Register File)')
        for sig in Signal_External:
            sname, where, io, stype, swidth = sig
            sname_i = f'i_{where}_{stype}_{sname}'
            sname_o = f'o_{where}_{stype}_{sname}'
            wname_i = f'{stage}_{sname}_i'
            wname_o = f'{stage}_{sname}_o'
            if swidth == 1:
                swidth = '\t'
            else:
                swidth = f'[{swidth-1}:0]'

            if where == stage:
                if io == 'i':
                    header['input'].append((sname_i, wname_i, swidth))
                    content.append(f'wire\t{swidth}\t{wname_i};')
                else:
                    header['output'].append((sname_o, wname_o, swidth))
                    content.append(f'wire\t{swidth}\t{wname_o};')
        
        content.append('')
        
        fgen.write(f'{stage} {stage.lower()}(\n\t.clk(clk), .nrst(nrst)\n')
        fgen.write(f'\t/* --- input --- */\n')
        for sig in header['input']:
            fgen.write(f'\t.{sig[0]}({sig[1]})\n')
        fgen.write(f'\t/* --- output --- */\n')
        for sig in header['output']:
            fgen.write(f'\t.{sig[0]}({sig[1]})\n')
        fgen.write(f'\t/* --- bypass --- */\n')
        for sig in header['bypass']:
            fgen.write(f'\t.{sig[0]}({sig[1]})\n')
        fgen.write(f');\n\n')
        fgen.flush()
    
    fgen.write('\n'.join(content))
    fgen.flush()


if __name__ == '__main__':
    fgen = open('mips.gen', 'w')
    GenStage(fgen)
    GenTop(fgen)
    fgen.close()
