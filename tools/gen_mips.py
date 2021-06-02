# net name = [I/O]_[STAGE]_[TYPE]_[SIGNAME]
GLOBAL = ['clk', 'nrst']
GLOBAL_REG = ['stall', 'bubble']
STAGE = ['IF', 'IF_ID_Reg', 'ID', 'ID_EX_Reg', 'EX', 'EX_MEM_Reg', 'MEM', 'MEM_WB_Reg', 'WB']
TYPE = ['data', 'ctrl', 'mem', 'reg']

Signal = [
    ('PCNext',      'IF', 'EX',     'data', 32),
    ('instruction', 'IF', 'ID',     'data', 32),
    ('RSData',      'ID', 'EX',     'data', 32),
    ('RTData',      'ID', 'MEM',    'data', 32),
    ('RSAddr',      'ID', 'EX',     'data', 5),
    ('RTAddr',      'ID', 'EX',     'data', 5),
    ('RDAddr',      'ID', 'EX',     'data', 5),
    ('ExtImm',      'ID', 'EX',     'data', 32),
    ('Shamt',       'ID', 'EX',     'data', 5),
    ('Funct',       'ID', 'EX',     'data', 6),
    ('ALUOp',       'ID', 'EX',     'ctrl', 4),
    ('ALUSrc',      'ID', 'EX',     'ctrl', 1),
    ('RegDst',      'ID', 'EX',     'ctrl', 1),
    ('Jump',        'ID', 'EX',     'ctrl', 2),
    ('Branch',      'ID', 'EX',     'ctrl', 2),
    ('MemWrite',    'ID', 'MEM',    'ctrl', 1),
    ('MemRead',     'ID', 'MEM',    'ctrl', 1),
    ('Mem2Reg',     'ID', 'WB',     'ctrl', 1),
    ('RegWrite',    'ID', 'WB',     'ctrl', 1),
    ('ALUOut',      'EX', 'MEM',    'data', 32),
    ('Overflow',    'EX', 'MEM',    'data', 1),
    ('RegAddrW',    'EX', 'WB',     'data', 5),
    ('MemData',     'MEM','WB',     'data', 32),
    ('ALUData',     'MEM','WB',     'data', 32)
]

Signal_Next = [
    ('PCSrc',       'EX', 'IF',     'ctrl', 1),
    ('PCBranch',    'EX', 'IF',     'data', 32)
]

Signal_External = [
    ('RegAddr1',    'ID', 'o',      'reg', 5),
    ('RegAddr2',    'ID', 'o',      'reg', 5),
    ('RegData1',    'ID', 'i',      'reg', 32),
    ('RegData2',    'ID', 'i',      'reg', 32),
    ('RegAddrW',    'WB', 'o',      'reg', 5),
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
        interface = {'input': [], 'output': [], 'bypass': []}   # module interface: input ports, output ports, bypass signals
        content = {'assign': [], 'clk': [], 'rst': []}          # code inside module

        ''' ----- elaborate ----- '''
        for sig in Signal:
            sname, start, end, stype, width = sig   # signal name, start stage, end stage, signal type, width
            pname_i = f'i_{end}_{stype}_{sname}'    # input port name
            pname_o = f'o_{end}_{stype}_{sname}'    # output port name
            if width == 1:
                swidth = '\t'                       # width string
            else:
                swidth = f'[{width-1}:0]'

            if start == stage:
                interface['output'].append(f'output\twire\t{swidth}\t{pname_o}')
            elif end == stage:
                interface['input'].append(f'input\twire\t{swidth}\t{pname_i}')
            elif STAGE.index(start) < i and STAGE.index(end) > i:
                if stage.find('_Reg') == -1:
                    interface['bypass'].append(f'input\twire\t{swidth}\t{pname_i}')
                    interface['bypass'].append(f'output\twire\t{swidth}\t{pname_o}')
                    content['assign'].append(f'assign {pname_o} = {pname_i};')
                else:
                    interface['bypass'].append(f'input\twire\t{swidth}\t{pname_i}')
                    interface['bypass'].append(f'output\treg \t{swidth}\t{pname_o}')
                    content['clk'].append(f'{pname_o} <= {pname_i};')
                    content['rst'].append(f'{pname_o} <= {width}\'d0;')
    
        for sig in Signal_Next:
            sname, start, end, stype, width = sig   # signal name, start stage, end stage, signal type, width
            pname_i = f'i_{end}_{stype}_{sname}'    # input port name
            pname_o = f'o_{end}_{stype}_{sname}'    # output port name
            if width == 1:
                swidth = '\t'                       # width string
            else:
                swidth = f'[{width-1}:0]'

            if start == stage:
                interface['output'].append(f'output\twire\t{swidth}\t{pname_o}')
            elif end == stage:
                interface['input'].append(f'input\twire\t{swidth}\t{pname_i}')
        
        for sig in Signal_External:
            sname, where, io, stype, width = sig    # signal name, stage, io, signal type, width
            pname_i = f'i_{where}_{stype}_{sname}'  # input port name
            pname_o = f'o_{where}_{stype}_{sname}'  # output port name
            if width == 1:
                swidth = '\t'                       # width string
            else:
                swidth = f'[{width-1}:0]'

            if where == stage:
                if io == 'i':
                    interface['input'].append(f'input\twire\t{swidth}\t{pname_i}')
                else:
                    interface['output'].append(f'output\twire\t{swidth}\t{pname_o}')

        ''' ----- generate verilog code for interfaces ----- '''
        gen_interface = []
        # global ports
        gen_interface.append('\tGLOBAL')
        for port in GLOBAL:
            gen_interface.append(f'input\twire\t{port}')
        if stage.find('_Reg') != -1:
            for port in GLOBAL_REG:
                gen_interface.append(f'input\twire\t{port}')
        # input ports
        if len(interface['input']) > 0:
            gen_interface.append('INPUT')
            gen_interface = gen_interface + interface['input']
        # output ports
        if len(interface['output']) > 0:
            gen_interface.append('OUTPUT')
            gen_interface = gen_interface + interface['output']
        # bypass signals
        if len(interface['bypass']) > 0:
            gen_interface.append('BYPASS')
            gen_interface = gen_interface + interface['bypass']

        gen_interface = ',\n\t'.join(gen_interface)
        repl = ['GLOBAL', 'INPUT', 'OUTPUT', 'BYPASS']
        for r in repl:
            gen_interface = gen_interface.replace(r + ',', f'/* --- {r.lower()} --- */')
        
        fgen.write(
            f'module {stage}(\n'
            f'{gen_interface}\n'
            f');\n\n'
        )

        ''' ----- generate verilog code for contents ----- '''
        if stage.find('_Reg') == -1:
            if len(interface['output']) > 0:
                fgen.write('\t/* Output Assignment Begin */\n')
                for c in interface['output']:
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
            gen_rst_ = '\n\t\t\t\t\t'.join(content['rst'])
            gen_clk_ = '\n\t\t\t\t\t'.join(content['clk'])
            fgen.write(
                f'\talways @ (posedge clk or negedge nrst) begin\n'
                f'\t\tif (~nrst) begin\n'
                f'\t\t\t{gen_rst}\n'
                f'\t\tend\n'
                f'\t\telse begin\n'
                f'\t\t\tif (~stall) begin\n'
                f'\t\t\t\tif (bubble) begin\n'
                f'\t\t\t\t\t{gen_rst_}\n'
                f'\t\t\t\tend\n'
                f'\t\t\t\telse begin\n'
                f'\t\t\t\t\t{gen_clk_}\n'
                f'\t\t\t\tend\n'
                f'\t\t\tend\n'
                f'\t\tend\n'
                f'\tend\n'
            )

        fgen.write('\nendmodule\n\n\n')
        fgen.flush()


def GenTop(fgen):

    content = []

    for i, stage in enumerate(STAGE):
        interface = {'input': [], 'output': [], 'bypass': []}

        ''' ----- elaborate ----- '''
        for sig in Signal:
            sname, start, end, stype, width = sig   # signal name, start stage, end stage, signal type, width
            pname_i = f'i_{end}_{stype}_{sname}'    # input port name
            pname_o = f'o_{end}_{stype}_{sname}'    # output port name
            if width == 1:
                swidth = '\t'                       # width string
            else:
                swidth = f'[{width-1}:0]'

            if stage.find('_Reg') == -1:
                nname_i = f'{stage}_{sname}_i'      # input net name
                nname_o = f'{stage}_{sname}_o'      # output net name
            else:
                prev_stage = stage.split('_')[0]
                next_stage = stage.split('_')[1]
                nname_i = f'{prev_stage}_{sname}_o'
                nname_o = f'{next_stage}_{sname}_i'

            if start == stage:
                interface['output'].append(f'.{pname_o}({nname_o})')
                content.append(f'wire\t{swidth}\t{nname_o};')
            elif end == stage:
                interface['input'].append(f'.{pname_i}({nname_i})')
                content.append(f'wire\t{swidth}\t{nname_i};')
            elif STAGE.index(start) < i and STAGE.index(end) > i:
                interface['bypass'].append(f'.{pname_i}({nname_i})')
                interface['bypass'].append(f'.{pname_o}({nname_o})')
                if stage.find('_Reg') == -1:
                    content.append(f'wire\t{swidth}\t{nname_i};')
                    content.append(f'wire\t{swidth}\t{nname_o};')
    
        for sig in Signal_Next:
            sname, start, end, stype, width = sig   # signal name, start stage, end stage, signal type, width
            pname_i = f'i_{end}_{stype}_{sname}'    # input port name
            pname_o = f'o_{end}_{stype}_{sname}'    # output port name
            if width == 1:
                swidth = '\t'                       # width string
            else:
                swidth = f'[{width-1}:0]'

            nname_i = f'{stage}_{sname}_i'          # input net name
            nname_o = f'{stage}_{sname}_o'          # output net name

            if start == stage:
                interface['output'].append(f'.{pname_o}({nname_o})')
                content.append(f'wire\t{swidth}\t{nname_o}; assign {end}_{sname}_i = {start}_{sname}_o;')
            elif end == stage:
                interface['input'].append(f'.{pname_i}({nname_i})')
                content.append(f'wire\t{swidth}\t{nname_i};')

        if stage.find('_Reg') == -1:
            content.append(f'// {stage} external signal (connected to Memory or Register File)')
        for sig in Signal_External:
            sname, where, io, stype, width = sig    # signal name, stage, io, signal type, width
            pname_i = f'i_{where}_{stype}_{sname}'  # input port name
            pname_o = f'o_{where}_{stype}_{sname}'  # output port name
            if width == 1:
                swidth = '\t'                       # width string
            else:
                swidth = f'[{width-1}:0]'

            nname_i = f'{stage}_{sname}_i'          # input net name
            nname_o = f'{stage}_{sname}_o'          # output net name

            if where == stage:
                if io == 'i':
                    interface['input'].append(f'.{pname_i}({nname_i})')
                    content.append(f'wire\t{swidth}\t{nname_i};')
                else:
                    interface['output'].append(f'.{pname_o}({nname_o})')
                    content.append(f'wire\t{swidth}\t{nname_o};')
        
        content.append('') # start a new line
        
        ''' ----- generate verilog code for interfaces ----- '''
        gen_interface = []
        # global ports
        gen_interface.append('\tGLOBAL')
        for port in GLOBAL:
            gen_interface.append(f'.{port}({port})')
        if stage.find('_Reg') != -1:
            for port in GLOBAL_REG:
                gen_interface.append(f'.{port}(1\'b0)')
        # input ports
        if len(interface['input']) > 0:
            gen_interface.append('INPUT')
            gen_interface = gen_interface + interface['input']
        # output ports
        if len(interface['output']) > 0:
            gen_interface.append('OUTPUT')
            gen_interface = gen_interface + interface['output']
        # bypass signals
        if len(interface['bypass']) > 0:
            gen_interface.append('BYPASS')
            gen_interface = gen_interface + interface['bypass']

        gen_interface = ',\n\t'.join(gen_interface)
        repl = ['GLOBAL', 'INPUT', 'OUTPUT', 'BYPASS']
        for r in repl:
            gen_interface = gen_interface.replace(r + ',', f'/* --- {r.lower()} --- */')
        
        fgen.write(
            f'{stage} {stage.lower()}(\n'
            f'{gen_interface}\n'
            f');\n\n'
        )
        fgen.flush()
    
    ''' ----- generate verilog code for contents ----- '''
    fgen.write('\n'.join(content))
    fgen.flush()


if __name__ == '__main__':
    fgen = open('mips.gen', 'w')
    GenStage(fgen)
    GenTop(fgen)
    fgen.close()
