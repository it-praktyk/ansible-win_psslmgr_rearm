#!/usr/bin/python

# Copyright: (c) 2018, Wojciech Sciesinski <wojciech@sciesinski.net>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

ANSIBLE_METADATA = {'metadata_version': '1.1',
                    'status': ['preview'],
                    'supported_by': 'community'}

DOCUMENTATION = '''
---
module: win_psslmgr_rearm
short_description: Perform the rearm operation on the license using PSSlmgr module.
version_added: "2.6"
description:
    - Perform the rearm operation on the license using the PowerShell PSSlmgr module.
options:
    state:
        description:
            Desired status after an operation. Only one supported
        required: true
        type: string
        choises:
          - rearmed
    rearmscope:
        description:
            The scope of the rearm operation.
        required: false
        type: string
        choises:
          - windows
          - application
          - sku
        default: windows
    applicationid:
        description:
          - For scopes other than 'windows' ApplicationID
        required: false
        type: string

requirements:
    PSSlmgr PowerShell module on the managed node
author:
    Wojciech Sciesinski (@itpraktyk)
'''

RETURN = '''

restart_required:
    description: Return information if the operation required the managed host restart.
    type: bool
'''

EXAMPLES = r'''
# run the pester test provided in the src parameter.
- name: Rearm Office 2016 installation
    win_psslmgr:
      rearmscope: 'Application'
      applicationid: '98EBFE73-2084-4C97-932C-C0CD1643BEA7'
'''