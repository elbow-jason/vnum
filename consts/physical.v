module consts

import strings

struct PhysicalConstant {
	name        string
	value       f64
	unit        string
	uncertainty f64
}

pub fn (p PhysicalConstant) str() string {
	mut s := strings.new_builder(100)
	s.write('Name:        $p.name\n')
	s.write('Value:       $p.value\n')
	s.write('Unit:        $p.unit\n')
	s.write('Uncertainty: $p.uncertainty\n')
	return s.str()
}

pub const (
	physical_constants = {
		'Wien displacement law constant': PhysicalConstant{
			name: 'Wien displacement law constant'
			value: 0.0028977685
			unit: 'm K'
			uncertainty: 5.1e-09
		}
		'atomic unit of 1st hyperpolarizablity': PhysicalConstant{
			name: 'atomic unit of 1st hyperpolarizablity'
			value: 3.20636151e-53
			unit: 'C^3 m^3 J^-2'
			uncertainty: 2.8e-60
		}
		'atomic unit of 2nd hyperpolarizablity': PhysicalConstant{
			name: 'atomic unit of 2nd hyperpolarizablity'
			value: 6.2353808e-65
			unit: 'C^4 m^4 J^-3'
			uncertainty: 1.1e-71
		}
		'atomic unit of electric dipole moment': PhysicalConstant{
			name: 'atomic unit of electric dipole moment'
			value: 8.47835309e-30
			unit: 'C m'
			uncertainty: 7.3e-37
		}
		'atomic unit of electric polarizablity': PhysicalConstant{
			name: 'atomic unit of electric polarizablity'
			value: 1.648777274e-41
			unit: 'C^2 m^2 J^-1'
			uncertainty: 1.6e-49
		}
		'atomic unit of electric quadrupole moment': PhysicalConstant{
			name: 'atomic unit of electric quadrupole moment'
			value: 4.48655124e-40
			unit: 'C m^2'
			uncertainty: 3.9e-47
		}
		'atomic unit of magn. dipole moment': PhysicalConstant{
			name: 'atomic unit of magn. dipole moment'
			value: 1.8548019e-23
			unit: 'J T^-1'
			uncertainty: 1.6e-30
		}
		'atomic unit of magn. flux density': PhysicalConstant{
			name: 'atomic unit of magn. flux density'
			value: 235051.755
			unit: 'T'
			uncertainty: 0.0014
		}
		'deuteron magn. moment': PhysicalConstant{
			name: 'deuteron magn. moment'
			value: 4.33073482e-27
			unit: 'J T^-1'
			uncertainty: 3.8e-34
		}
		'deuteron magn. moment to Bohr magneton ratio': PhysicalConstant{
			name: 'deuteron magn. moment to Bohr magneton ratio'
			value: 0.0004669754567
			unit: ''
			uncertainty: 5e-12
		}
		'deuteron magn. moment to nuclear magneton ratio': PhysicalConstant{
			name: 'deuteron magn. moment to nuclear magneton ratio'
			value: 0.8574382329
			unit: ''
			uncertainty: 9.2e-09
		}
		'deuteron-electron magn. moment ratio': PhysicalConstant{
			name: 'deuteron-electron magn. moment ratio'
			value: -0.0004664345548
			unit: ''
			uncertainty: 5e-12
		}
		'deuteron-proton magn. moment ratio': PhysicalConstant{
			name: 'deuteron-proton magn. moment ratio'
			value: 0.3070122084
			unit: ''
			uncertainty: 4.5e-09
		}
		'deuteron-neutron magn. moment ratio': PhysicalConstant{
			name: 'deuteron-neutron magn. moment ratio'
			value: -0.44820652
			unit: ''
			uncertainty: 1.1e-07
		}
		'electron gyromagn. ratio': PhysicalConstant{
			name: 'electron gyromagn. ratio'
			value: 176085964400.0
			unit: 's^-1 T^-1'
			uncertainty: 1100.0
		}
		'electron gyromagn. ratio over 2 pi': PhysicalConstant{
			name: 'electron gyromagn. ratio over 2 pi'
			value: 28024.95164
			unit: 'MHz T^-1'
			uncertainty: 0.00017
		}
		'electron magn. moment': PhysicalConstant{
			name: 'electron magn. moment'
			value: -9.28476412e-24
			unit: 'J T^-1'
			uncertainty: 8e-31
		}
		'electron magn. moment to Bohr magneton ratio': PhysicalConstant{
			name: 'electron magn. moment to Bohr magneton ratio'
			value: -1.0011596521859
			unit: ''
			uncertainty: 3.8e-12
		}
		'electron magn. moment to nuclear magneton ratio': PhysicalConstant{
			name: 'electron magn. moment to nuclear magneton ratio'
			value: -1838.28197107
			unit: ''
			uncertainty: 8.5e-07
		}
		'electron magn. moment anomaly': PhysicalConstant{
			name: 'electron magn. moment anomaly'
			value: 0.0011596521859
			unit: ''
			uncertainty: 3.8e-12
		}
		'electron to shielded proton magn. moment ratio': PhysicalConstant{
			name: 'electron to shielded proton magn. moment ratio'
			value: -658.2275956
			unit: ''
			uncertainty: 7.1e-06
		}
		'electron to shielded helion magn. moment ratio': PhysicalConstant{
			name: 'electron to shielded helion magn. moment ratio'
			value: 864.058255
			unit: ''
			uncertainty: 1e-05
		}
		'electron-deuteron magn. moment ratio': PhysicalConstant{
			name: 'electron-deuteron magn. moment ratio'
			value: -2143.923493
			unit: ''
			uncertainty: 2.3e-05
		}
		'electron-muon magn. moment ratio': PhysicalConstant{
			name: 'electron-muon magn. moment ratio'
			value: 206.7669894
			unit: ''
			uncertainty: 5.4e-06
		}
		'electron-neutron magn. moment ratio': PhysicalConstant{
			name: 'electron-neutron magn. moment ratio'
			value: 960.9205
			unit: ''
			uncertainty: 0.00023
		}
		'electron-proton magn. moment ratio': PhysicalConstant{
			name: 'electron-proton magn. moment ratio'
			value: -658.2106862
			unit: ''
			uncertainty: 6.6e-06
		}
		'magn. constant': PhysicalConstant{
			name: 'magn. constant'
			value: 1.2566370614359173e-06
			unit: 'N A^-2'
			uncertainty: 0.0
		}
		'magn. flux quantum': PhysicalConstant{
			name: 'magn. flux quantum'
			value: 2.067833831e-15
			unit: 'Wb'
			uncertainty: 1.3e-23
		}
		'muon magn. moment': PhysicalConstant{
			name: 'muon magn. moment'
			value: -4.49044799e-26
			unit: 'J T^-1'
			uncertainty: 4e-33
		}
		'muon magn. moment to Bohr magneton ratio': PhysicalConstant{
			name: 'muon magn. moment to Bohr magneton ratio'
			value: -0.00484197045
			unit: ''
			uncertainty: 1.3e-10
		}
		'muon magn. moment to nuclear magneton ratio': PhysicalConstant{
			name: 'muon magn. moment to nuclear magneton ratio'
			value: -8.89059698
			unit: ''
			uncertainty: 2.3e-07
		}
		'muon-proton magn. moment ratio': PhysicalConstant{
			name: 'muon-proton magn. moment ratio'
			value: -3.183345118
			unit: ''
			uncertainty: 8.9e-08
		}
		'neutron gyromagn. ratio': PhysicalConstant{
			name: 'neutron gyromagn. ratio'
			value: 183247172.0
			unit: 's^-1 T^-1'
			uncertainty: 43.0
		}
		'neutron gyromagn. ratio over 2 pi': PhysicalConstant{
			name: 'neutron gyromagn. ratio over 2 pi'
			value: 29.1646933
			unit: 'MHz T^-1'
			uncertainty: 6.9e-06
		}
		'neutron magn. moment': PhysicalConstant{
			name: 'neutron magn. moment'
			value: -9.6623645e-27
			unit: 'J T^-1'
			uncertainty: 2.4e-33
		}
		'neutron magn. moment to Bohr magneton ratio': PhysicalConstant{
			name: 'neutron magn. moment to Bohr magneton ratio'
			value: -0.00104187563
			unit: ''
			uncertainty: 2.5e-10
		}
		'neutron magn. moment to nuclear magneton ratio': PhysicalConstant{
			name: 'neutron magn. moment to nuclear magneton ratio'
			value: -1.91304273
			unit: ''
			uncertainty: 4.5e-07
		}
		'neutron to shielded proton magn. moment ratio': PhysicalConstant{
			name: 'neutron to shielded proton magn. moment ratio'
			value: -0.68499694
			unit: ''
			uncertainty: 1.6e-07
		}
		'neutron-electron magn. moment ratio': PhysicalConstant{
			name: 'neutron-electron magn. moment ratio'
			value: 0.00104066882
			unit: ''
			uncertainty: 2.5e-10
		}
		'neutron-proton magn. moment ratio': PhysicalConstant{
			name: 'neutron-proton magn. moment ratio'
			value: -0.68497934
			unit: ''
			uncertainty: 1.6e-07
		}
		'proton gyromagn. ratio': PhysicalConstant{
			name: 'proton gyromagn. ratio'
			value: 267522190.0
			unit: 's^-1 T^-1'
			uncertainty: 1.8
		}
		'proton gyromagn. ratio over 2 pi': PhysicalConstant{
			name: 'proton gyromagn. ratio over 2 pi'
			value: 42.57747892
			unit: 'MHz T^-1'
			uncertainty: 2.9e-07
		}
		'proton magn. moment': PhysicalConstant{
			name: 'proton magn. moment'
			value: 1.41060671e-26
			unit: 'J T^-1'
			uncertainty: 1.2e-33
		}
		'proton magn. moment to Bohr magneton ratio': PhysicalConstant{
			name: 'proton magn. moment to Bohr magneton ratio'
			value: 0.001521032206
			unit: ''
			uncertainty: 1.5e-11
		}
		'proton magn. moment to nuclear magneton ratio': PhysicalConstant{
			name: 'proton magn. moment to nuclear magneton ratio'
			value: 2.792847351
			unit: ''
			uncertainty: 2.8e-08
		}
		'proton magn. shielding correction': PhysicalConstant{
			name: 'proton magn. shielding correction'
			value: 2.5691e-05
			unit: ''
			uncertainty: 1.1e-08
		}
		'proton-neutron magn. moment ratio': PhysicalConstant{
			name: 'proton-neutron magn. moment ratio'
			value: -1.45989805
			unit: ''
			uncertainty: 3.4e-07
		}
		'shielded helion gyromagn. ratio': PhysicalConstant{
			name: 'shielded helion gyromagn. ratio'
			value: 203789458.5
			unit: 's^-1 T^-1'
			uncertainty: 2.7
		}
		'shielded helion gyromagn. ratio over 2 pi': PhysicalConstant{
			name: 'shielded helion gyromagn. ratio over 2 pi'
			value: 32.43409966
			unit: 'MHz T^-1'
			uncertainty: 4.3e-07
		}
		'shielded helion magn. moment': PhysicalConstant{
			name: 'shielded helion magn. moment'
			value: -1.074553024e-26
			unit: 'J T^-1'
			uncertainty: 9.3e-34
		}
		'shielded helion magn. moment to Bohr magneton ratio': PhysicalConstant{
			name: 'shielded helion magn. moment to Bohr magneton ratio'
			value: -0.001158671474
			unit: ''
			uncertainty: 1.4e-11
		}
		'shielded helion magn. moment to nuclear magneton ratio': PhysicalConstant{
			name: 'shielded helion magn. moment to nuclear magneton ratio'
			value: -2.127497723
			unit: ''
			uncertainty: 2.5e-08
		}
		'shielded helion to proton magn. moment ratio': PhysicalConstant{
			name: 'shielded helion to proton magn. moment ratio'
			value: -0.761766562
			unit: ''
			uncertainty: 1.2e-08
		}
		'shielded helion to shielded proton magn. moment ratio': PhysicalConstant{
			name: 'shielded helion to shielded proton magn. moment ratio'
			value: -0.7617861313
			unit: ''
			uncertainty: 3.3e-09
		}
		'shielded proton magn. moment': PhysicalConstant{
			name: 'shielded proton magn. moment'
			value: 1.41057047e-26
			unit: 'J T^-1'
			uncertainty: 1.2e-33
		}
		'shielded proton magn. moment to Bohr magneton ratio': PhysicalConstant{
			name: 'shielded proton magn. moment to Bohr magneton ratio'
			value: 0.001520993132
			unit: ''
			uncertainty: 1.6e-11
		}
		'shielded proton magn. moment to nuclear magneton ratio': PhysicalConstant{
			name: 'shielded proton magn. moment to nuclear magneton ratio'
			value: 2.792775604
			unit: ''
			uncertainty: 3e-08
		}
		'{220} lattice spacing of silicon': PhysicalConstant{
			name: '{220} lattice spacing of silicon'
			value: 1.920155714e-10
			unit: 'm'
			uncertainty: 3.2e-18
		}
		'lattice spacing of silicon': PhysicalConstant{
			name: 'lattice spacing of silicon'
			value: 1.920155762e-10
			unit: 'm'
			uncertainty: 5e-18
		}
		'alpha particle-electron mass ratio': PhysicalConstant{
			name: 'alpha particle-electron mass ratio'
			value: 7294.29954136
			unit: ''
			uncertainty: 2.4e-07
		}
		'alpha particle mass': PhysicalConstant{
			name: 'alpha particle mass'
			value: 6.64465723e-27
			unit: 'kg'
			uncertainty: 8.2e-35
		}
		'alpha particle mass energy equivalent': PhysicalConstant{
			name: 'alpha particle mass energy equivalent'
			value: 5.971920097e-10
			unit: 'J'
			uncertainty: 7.3e-18
		}
		'alpha particle mass energy equivalent in MeV': PhysicalConstant{
			name: 'alpha particle mass energy equivalent in MeV'
			value: 3727.379378
			unit: 'MeV'
			uncertainty: 2.3e-05
		}
		'alpha particle mass in u': PhysicalConstant{
			name: 'alpha particle mass in u'
			value: 4.001506179127
			unit: 'u'
			uncertainty: 6.3e-11
		}
		'alpha particle molar mass': PhysicalConstant{
			name: 'alpha particle molar mass'
			value: 0.004001506179127
			unit: 'kg mol^-1'
			uncertainty: 6.3e-14
		}
		'alpha particle-proton mass ratio': PhysicalConstant{
			name: 'alpha particle-proton mass ratio'
			value: 3.97259968907
			unit: ''
			uncertainty: 3.6e-10
		}
		'Angstrom star': PhysicalConstant{
			name: 'Angstrom star'
			value: 1.00001495e-10
			unit: 'm'
			uncertainty: 9e-17
		}
		'atomic mass constant': PhysicalConstant{
			name: 'atomic mass constant'
			value: 1.66053904e-27
			unit: 'kg'
			uncertainty: 2e-35
		}
		'atomic mass constant energy equivalent': PhysicalConstant{
			name: 'atomic mass constant energy equivalent'
			value: 1.492418062e-10
			unit: 'J'
			uncertainty: 1.8e-18
		}
		'atomic mass constant energy equivalent in MeV': PhysicalConstant{
			name: 'atomic mass constant energy equivalent in MeV'
			value: 931.4940954
			unit: 'MeV'
			uncertainty: 5.7e-06
		}
		'atomic mass unit-electron volt relationship': PhysicalConstant{
			name: 'atomic mass unit-electron volt relationship'
			value: 931494095.4
			unit: 'eV'
			uncertainty: 5.7
		}
		'atomic mass unit-hartree relationship': PhysicalConstant{
			name: 'atomic mass unit-hartree relationship'
			value: 34231776.902
			unit: 'E_h'
			uncertainty: 0.016
		}
		'atomic mass unit-hertz relationship': PhysicalConstant{
			name: 'atomic mass unit-hertz relationship'
			value: 2.2523427206e+23
			unit: 'Hz'
			uncertainty: 100000000000000.0
		}
		'atomic mass unit-inverse meter relationship': PhysicalConstant{
			name: 'atomic mass unit-inverse meter relationship'
			value: 751300661660000.0
			unit: 'm^-1'
			uncertainty: 340000.0
		}
		'atomic mass unit-joule relationship': PhysicalConstant{
			name: 'atomic mass unit-joule relationship'
			value: 1.492418062e-10
			unit: 'J'
			uncertainty: 1.8e-18
		}
		'atomic mass unit-kelvin relationship': PhysicalConstant{
			name: 'atomic mass unit-kelvin relationship'
			value: 10809543800000.0
			unit: 'K'
			uncertainty: 6200000.0
		}
		'atomic mass unit-kilogram relationship': PhysicalConstant{
			name: 'atomic mass unit-kilogram relationship'
			value: 1.66053904e-27
			unit: 'kg'
			uncertainty: 2e-35
		}
		'atomic unit of 1st hyperpolarizability': PhysicalConstant{
			name: 'atomic unit of 1st hyperpolarizability'
			value: 3.206361329e-53
			unit: 'C^3 m^3 J^-2'
			uncertainty: 2e-61
		}
		'atomic unit of 2nd hyperpolarizability': PhysicalConstant{
			name: 'atomic unit of 2nd hyperpolarizability'
			value: 6.235380085e-65
			unit: 'C^4 m^4 J^-3'
			uncertainty: 7.7e-73
		}
		'atomic unit of action': PhysicalConstant{
			name: 'atomic unit of action'
			value: 1.0545718e-34
			unit: 'J s'
			uncertainty: 1.3e-42
		}
		'atomic unit of charge': PhysicalConstant{
			name: 'atomic unit of charge'
			value: 1.6021766208e-19
			unit: 'C'
			uncertainty: 9.8e-28
		}
		'atomic unit of charge density': PhysicalConstant{
			name: 'atomic unit of charge density'
			value: 1081202377000.0
			unit: 'C m^-3'
			uncertainty: 6700.0
		}
		'atomic unit of current': PhysicalConstant{
			name: 'atomic unit of current'
			value: 0.006623618183
			unit: 'A'
			uncertainty: 4.1e-11
		}
		'atomic unit of electric dipole mom.': PhysicalConstant{
			name: 'atomic unit of electric dipole mom.'
			value: 8.478353552e-30
			unit: 'C m'
			uncertainty: 5.2e-38
		}
		'atomic unit of electric field': PhysicalConstant{
			name: 'atomic unit of electric field'
			value: 514220670700.0
			unit: 'V m^-1'
			uncertainty: 3200.0
		}
		'atomic unit of electric field gradient': PhysicalConstant{
			name: 'atomic unit of electric field gradient'
			value: 9.717362356e+21
			unit: 'V m^-2'
			uncertainty: 60000000000000.0
		}
		'atomic unit of electric polarizability': PhysicalConstant{
			name: 'atomic unit of electric polarizability'
			value: 1.6487772731e-41
			unit: 'C^2 m^2 J^-1'
			uncertainty: 1.1e-50
		}
		'atomic unit of electric potential': PhysicalConstant{
			name: 'atomic unit of electric potential'
			value: 27.21138602
			unit: 'V'
			uncertainty: 1.7e-07
		}
		'atomic unit of electric quadrupole mom.': PhysicalConstant{
			name: 'atomic unit of electric quadrupole mom.'
			value: 4.486551484e-40
			unit: 'C m^2'
			uncertainty: 2.8e-48
		}
		'atomic unit of energy': PhysicalConstant{
			name: 'atomic unit of energy'
			value: 4.35974465e-18
			unit: 'J'
			uncertainty: 5.4e-26
		}
		'atomic unit of force': PhysicalConstant{
			name: 'atomic unit of force'
			value: 8.23872336e-08
			unit: 'N'
			uncertainty: 1e-15
		}
		'atomic unit of length': PhysicalConstant{
			name: 'atomic unit of length'
			value: 5.2917721067e-11
			unit: 'm'
			uncertainty: 1.2e-20
		}
		'atomic unit of mag. dipole mom.': PhysicalConstant{
			name: 'atomic unit of mag. dipole mom.'
			value: 1.854801999e-23
			unit: 'J T^-1'
			uncertainty: 1.1e-31
		}
		'atomic unit of mag. flux density': PhysicalConstant{
			name: 'atomic unit of mag. flux density'
			value: 235051.755
			unit: 'T'
			uncertainty: 0.0014
		}
		'atomic unit of magnetizability': PhysicalConstant{
			name: 'atomic unit of magnetizability'
			value: 7.8910365886e-29
			unit: 'J T^-2'
			uncertainty: 9e-38
		}
		'atomic unit of mass': PhysicalConstant{
			name: 'atomic unit of mass'
			value: 9.10938356e-31
			unit: 'kg'
			uncertainty: 1.1e-38
		}
		'atomic unit of momentum': PhysicalConstant{
			name: 'atomic unit of momentum'
			value: 1.992851882e-24
			unit: 'kg m s^-1'
			uncertainty: 2.4e-32
		}
		'atomic unit of permittivity': PhysicalConstant{
			name: 'atomic unit of permittivity'
			value: 1.1126500560536183e-10
			unit: 'F m^-1'
			uncertainty: 0.0
		}
		'atomic unit of time': PhysicalConstant{
			name: 'atomic unit of time'
			value: 2.418884326509e-17
			unit: 's'
			uncertainty: 1.4e-28
		}
		'atomic unit of velocity': PhysicalConstant{
			name: 'atomic unit of velocity'
			value: 2187691.26277
			unit: 'm s^-1'
			uncertainty: 0.0005
		}
		'Avogadro constant': PhysicalConstant{
			name: 'Avogadro constant'
			value: 6.022140857e+23
			unit: 'mol^-1'
			uncertainty: 7400000000000000.0
		}
		'Bohr magneton': PhysicalConstant{
			name: 'Bohr magneton'
			value: 9.274009994e-24
			unit: 'J T^-1'
			uncertainty: 5.7e-32
		}
		'Bohr magneton in eV/T': PhysicalConstant{
			name: 'Bohr magneton in eV/T'
			value: 5.7883818012e-05
			unit: 'eV T^-1'
			uncertainty: 2.6e-14
		}
		'Bohr magneton in Hz/T': PhysicalConstant{
			name: 'Bohr magneton in Hz/T'
			value: 13996245042.0
			unit: 'Hz T^-1'
			uncertainty: 86.0
		}
		'Bohr magneton in inverse meters per tesla': PhysicalConstant{
			name: 'Bohr magneton in inverse meters per tesla'
			value: 46.68644814
			unit: 'm^-1 T^-1'
			uncertainty: 2.9e-07
		}
		'Bohr magneton in K/T': PhysicalConstant{
			name: 'Bohr magneton in K/T'
			value: 0.67171405
			unit: 'K T^-1'
			uncertainty: 3.9e-07
		}
		'Bohr radius': PhysicalConstant{
			name: 'Bohr radius'
			value: 5.2917721067e-11
			unit: 'm'
			uncertainty: 1.2e-20
		}
		'Boltzmann constant': PhysicalConstant{
			name: 'Boltzmann constant'
			value: 1.38064852e-23
			unit: 'J K^-1'
			uncertainty: 7.9e-30
		}
		'Boltzmann constant in eV/K': PhysicalConstant{
			name: 'Boltzmann constant in eV/K'
			value: 8.6173303e-05
			unit: 'eV K^-1'
			uncertainty: 5e-11
		}
		'Boltzmann constant in Hz/K': PhysicalConstant{
			name: 'Boltzmann constant in Hz/K'
			value: 20836612000.0
			unit: 'Hz K^-1'
			uncertainty: 12000.0
		}
		'Boltzmann constant in inverse meters per kelvin': PhysicalConstant{
			name: 'Boltzmann constant in inverse meters per kelvin'
			value: 69.503457
			unit: 'm^-1 K^-1'
			uncertainty: 4e-05
		}
		'characteristic impedance of vacuum': PhysicalConstant{
			name: 'characteristic impedance of vacuum'
			value: 376.73031346177066
			unit: 'ohm'
			uncertainty: 0.0
		}
		'classical electron radius': PhysicalConstant{
			name: 'classical electron radius'
			value: 2.8179403227e-15
			unit: 'm'
			uncertainty: 1.9e-24
		}
		'Compton wavelength': PhysicalConstant{
			name: 'Compton wavelength'
			value: 2.4263102367e-12
			unit: 'm'
			uncertainty: 1.1e-21
		}
		'Compton wavelength over 2 pi': PhysicalConstant{
			name: 'Compton wavelength over 2 pi'
			value: 3.8615926764e-13
			unit: 'm'
			uncertainty: 1.8e-22
		}
		'conductance quantum': PhysicalConstant{
			name: 'conductance quantum'
			value: 7.748091731e-05
			unit: 'S'
			uncertainty: 1.8e-14
		}
		'conventional value of Josephson constant': PhysicalConstant{
			name: 'conventional value of Josephson constant'
			value: 483597900000000.0
			unit: 'Hz V^-1'
			uncertainty: 0.0
		}
		'conventional value of von Klitzing constant': PhysicalConstant{
			name: 'conventional value of von Klitzing constant'
			value: 25812.807
			unit: 'ohm'
			uncertainty: 0.0
		}
		'Cu x unit': PhysicalConstant{
			name: 'Cu x unit'
			value: 1.00207697e-13
			unit: 'm'
			uncertainty: 2.8e-20
		}
		'deuteron-electron mag. mom. ratio': PhysicalConstant{
			name: 'deuteron-electron mag. mom. ratio'
			value: -0.0004664345535
			unit: ''
			uncertainty: 2.6e-12
		}
		'deuteron-electron mass ratio': PhysicalConstant{
			name: 'deuteron-electron mass ratio'
			value: 3670.48296785
			unit: ''
			uncertainty: 1.3e-07
		}
		'deuteron g factor': PhysicalConstant{
			name: 'deuteron g factor'
			value: 0.8574382311
			unit: ''
			uncertainty: 4.8e-09
		}
		'deuteron mag. mom.': PhysicalConstant{
			name: 'deuteron mag. mom.'
			value: 4.33073504e-27
			unit: 'J T^-1'
			uncertainty: 3.6e-35
		}
		'deuteron mag. mom. to Bohr magneton ratio': PhysicalConstant{
			name: 'deuteron mag. mom. to Bohr magneton ratio'
			value: 0.0004669754554
			unit: ''
			uncertainty: 2.6e-12
		}
		'deuteron mag. mom. to nuclear magneton ratio': PhysicalConstant{
			name: 'deuteron mag. mom. to nuclear magneton ratio'
			value: 0.8574382311
			unit: ''
			uncertainty: 4.8e-09
		}
		'deuteron mass': PhysicalConstant{
			name: 'deuteron mass'
			value: 3.343583719e-27
			unit: 'kg'
			uncertainty: 4.1e-35
		}
		'deuteron mass energy equivalent': PhysicalConstant{
			name: 'deuteron mass energy equivalent'
			value: 3.005063183e-10
			unit: 'J'
			uncertainty: 3.7e-18
		}
		'deuteron mass energy equivalent in MeV': PhysicalConstant{
			name: 'deuteron mass energy equivalent in MeV'
			value: 1875.612928
			unit: 'MeV'
			uncertainty: 1.2e-05
		}
		'deuteron mass in u': PhysicalConstant{
			name: 'deuteron mass in u'
			value: 2.013553212745
			unit: 'u'
			uncertainty: 4e-11
		}
		'deuteron molar mass': PhysicalConstant{
			name: 'deuteron molar mass'
			value: 0.002013553212745
			unit: 'kg mol^-1'
			uncertainty: 4e-14
		}
		'deuteron-neutron mag. mom. ratio': PhysicalConstant{
			name: 'deuteron-neutron mag. mom. ratio'
			value: -0.44820652
			unit: ''
			uncertainty: 1.1e-07
		}
		'deuteron-proton mag. mom. ratio': PhysicalConstant{
			name: 'deuteron-proton mag. mom. ratio'
			value: 0.3070122077
			unit: ''
			uncertainty: 1.5e-09
		}
		'deuteron-proton mass ratio': PhysicalConstant{
			name: 'deuteron-proton mass ratio'
			value: 1.99900750087
			unit: ''
			uncertainty: 1.9e-10
		}
		'deuteron rms charge radius': PhysicalConstant{
			name: 'deuteron rms charge radius'
			value: 2.1413e-15
			unit: 'm'
			uncertainty: 2.5e-18
		}
		'electric constant': PhysicalConstant{
			name: 'electric constant'
			value: 8.854187817620389e-12
			unit: 'F m^-1'
			uncertainty: 0.0
		}
		'electron charge to mass quotient': PhysicalConstant{
			name: 'electron charge to mass quotient'
			value: -175882002400.0
			unit: 'C kg^-1'
			uncertainty: 1100.0
		}
		'electron-deuteron mag. mom. ratio': PhysicalConstant{
			name: 'electron-deuteron mag. mom. ratio'
			value: -2143.923499
			unit: ''
			uncertainty: 1.2e-05
		}
		'electron-deuteron mass ratio': PhysicalConstant{
			name: 'electron-deuteron mass ratio'
			value: 0.0002724437107484
			unit: ''
			uncertainty: 9.6e-15
		}
		'electron g factor': PhysicalConstant{
			name: 'electron g factor'
			value: -2.00231930436182
			unit: ''
			uncertainty: 5.2e-13
		}
		'electron gyromag. ratio': PhysicalConstant{
			name: 'electron gyromag. ratio'
			value: 176085964400.0
			unit: 's^-1 T^-1'
			uncertainty: 1100.0
		}
		'electron gyromag. ratio over 2 pi': PhysicalConstant{
			name: 'electron gyromag. ratio over 2 pi'
			value: 28024.95164
			unit: 'MHz T^-1'
			uncertainty: 0.00017
		}
		'electron mag. mom.': PhysicalConstant{
			name: 'electron mag. mom.'
			value: -9.28476462e-24
			unit: 'J T^-1'
			uncertainty: 5.7e-32
		}
		'electron mag. mom. anomaly': PhysicalConstant{
			name: 'electron mag. mom. anomaly'
			value: 0.00115965218091
			unit: ''
			uncertainty: 2.6e-13
		}
		'electron mag. mom. to Bohr magneton ratio': PhysicalConstant{
			name: 'electron mag. mom. to Bohr magneton ratio'
			value: -1.00115965218091
			unit: ''
			uncertainty: 2.6e-13
		}
		'electron mag. mom. to nuclear magneton ratio': PhysicalConstant{
			name: 'electron mag. mom. to nuclear magneton ratio'
			value: -1838.28197234
			unit: ''
			uncertainty: 1.7e-07
		}
		'electron mass': PhysicalConstant{
			name: 'electron mass'
			value: 9.10938356e-31
			unit: 'kg'
			uncertainty: 1.1e-38
		}
		'electron mass energy equivalent': PhysicalConstant{
			name: 'electron mass energy equivalent'
			value: 8.18710565e-14
			unit: 'J'
			uncertainty: 1e-21
		}
		'electron mass energy equivalent in MeV': PhysicalConstant{
			name: 'electron mass energy equivalent in MeV'
			value: 0.5109989461
			unit: 'MeV'
			uncertainty: 3.1e-09
		}
		'electron mass in u': PhysicalConstant{
			name: 'electron mass in u'
			value: 0.00054857990907
			unit: 'u'
			uncertainty: 1.6e-14
		}
		'electron molar mass': PhysicalConstant{
			name: 'electron molar mass'
			value: 5.4857990907e-07
			unit: 'kg mol^-1'
			uncertainty: 1.6e-17
		}
		'electron-muon mag. mom. ratio': PhysicalConstant{
			name: 'electron-muon mag. mom. ratio'
			value: 206.766988
			unit: ''
			uncertainty: 4.6e-06
		}
		'electron-muon mass ratio': PhysicalConstant{
			name: 'electron-muon mass ratio'
			value: 0.0048363317
			unit: ''
			uncertainty: 1.1e-10
		}
		'electron-neutron mag. mom. ratio': PhysicalConstant{
			name: 'electron-neutron mag. mom. ratio'
			value: 960.9205
			unit: ''
			uncertainty: 0.00023
		}
		'electron-neutron mass ratio': PhysicalConstant{
			name: 'electron-neutron mass ratio'
			value: 0.00054386734428
			unit: ''
			uncertainty: 2.7e-13
		}
		'electron-proton mag. mom. ratio': PhysicalConstant{
			name: 'electron-proton mag. mom. ratio'
			value: -658.2106866
			unit: ''
			uncertainty: 2e-06
		}
		'electron-proton mass ratio': PhysicalConstant{
			name: 'electron-proton mass ratio'
			value: 0.000544617021352
			unit: ''
			uncertainty: 5.2e-14
		}
		'electron-tau mass ratio': PhysicalConstant{
			name: 'electron-tau mass ratio'
			value: 0.000287592
			unit: ''
			uncertainty: 2.6e-08
		}
		'electron to alpha particle mass ratio': PhysicalConstant{
			name: 'electron to alpha particle mass ratio'
			value: 0.0001370933554798
			unit: ''
			uncertainty: 4.5e-15
		}
		'electron to shielded helion mag. mom. ratio': PhysicalConstant{
			name: 'electron to shielded helion mag. mom. ratio'
			value: 864.058257
			unit: ''
			uncertainty: 1e-05
		}
		'electron to shielded proton mag. mom. ratio': PhysicalConstant{
			name: 'electron to shielded proton mag. mom. ratio'
			value: -658.2275971
			unit: ''
			uncertainty: 7.2e-06
		}
		'electron volt': PhysicalConstant{
			name: 'electron volt'
			value: 1.6021766208e-19
			unit: 'J'
			uncertainty: 9.8e-28
		}
		'electron volt-atomic mass unit relationship': PhysicalConstant{
			name: 'electron volt-atomic mass unit relationship'
			value: 1.0735441105e-09
			unit: 'u'
			uncertainty: 6.6e-18
		}
		'electron volt-hartree relationship': PhysicalConstant{
			name: 'electron volt-hartree relationship'
			value: 0.03674932248
			unit: 'E_h'
			uncertainty: 2.3e-10
		}
		'electron volt-hertz relationship': PhysicalConstant{
			name: 'electron volt-hertz relationship'
			value: 241798926200000.0
			unit: 'Hz'
			uncertainty: 1500000.0
		}
		'electron volt-inverse meter relationship': PhysicalConstant{
			name: 'electron volt-inverse meter relationship'
			value: 806554.4005
			unit: 'm^-1'
			uncertainty: 0.005
		}
		'electron volt-joule relationship': PhysicalConstant{
			name: 'electron volt-joule relationship'
			value: 1.6021766208e-19
			unit: 'J'
			uncertainty: 9.8e-28
		}
		'electron volt-kelvin relationship': PhysicalConstant{
			name: 'electron volt-kelvin relationship'
			value: 11604.5221
			unit: 'K'
			uncertainty: 0.0067
		}
		'electron volt-kilogram relationship': PhysicalConstant{
			name: 'electron volt-kilogram relationship'
			value: 1.782661907e-36
			unit: 'kg'
			uncertainty: 1.1e-44
		}
		'elementary charge': PhysicalConstant{
			name: 'elementary charge'
			value: 1.6021766208e-19
			unit: 'C'
			uncertainty: 9.8e-28
		}
		'elementary charge over h': PhysicalConstant{
			name: 'elementary charge over h'
			value: 241798926200000.0
			unit: 'A J^-1'
			uncertainty: 1500000.0
		}
		'Faraday constant': PhysicalConstant{
			name: 'Faraday constant'
			value: 96485.33289
			unit: 'C mol^-1'
			uncertainty: 0.00059
		}
		'Faraday constant for conventional electric current': PhysicalConstant{
			name: 'Faraday constant for conventional electric current'
			value: 96485.3251
			unit: 'C_90 mol^-1'
			uncertainty: 0.0012
		}
		'Fermi coupling constant': PhysicalConstant{
			name: 'Fermi coupling constant'
			value: 1.1663787e-05
			unit: 'GeV^-2'
			uncertainty: 6e-12
		}
		'fine-structure constant': PhysicalConstant{
			name: 'fine-structure constant'
			value: 0.0072973525664
			unit: ''
			uncertainty: 1.7e-12
		}
		'first radiation constant': PhysicalConstant{
			name: 'first radiation constant'
			value: 3.74177179e-16
			unit: 'W m^2'
			uncertainty: 4.6e-24
		}
		'first radiation constant for spectral radiance': PhysicalConstant{
			name: 'first radiation constant for spectral radiance'
			value: 1.191042953e-16
			unit: 'W m^2 sr^-1'
			uncertainty: 1.5e-24
		}
		'hartree-atomic mass unit relationship': PhysicalConstant{
			name: 'hartree-atomic mass unit relationship'
			value: 2.9212623197e-08
			unit: 'u'
			uncertainty: 1.3e-17
		}
		'hartree-electron volt relationship': PhysicalConstant{
			name: 'hartree-electron volt relationship'
			value: 27.21138602
			unit: 'eV'
			uncertainty: 1.7e-07
		}
		'Hartree energy': PhysicalConstant{
			name: 'Hartree energy'
			value: 4.35974465e-18
			unit: 'J'
			uncertainty: 5.4e-26
		}
		'Hartree energy in eV': PhysicalConstant{
			name: 'Hartree energy in eV'
			value: 27.21138602
			unit: 'eV'
			uncertainty: 1.7e-07
		}
		'hartree-hertz relationship': PhysicalConstant{
			name: 'hartree-hertz relationship'
			value: 6579683920711000.0
			unit: 'Hz'
			uncertainty: 39000.0
		}
		'hartree-inverse meter relationship': PhysicalConstant{
			name: 'hartree-inverse meter relationship'
			value: 21947463.13702
			unit: 'm^-1'
			uncertainty: 0.00013
		}
		'hartree-joule relationship': PhysicalConstant{
			name: 'hartree-joule relationship'
			value: 4.35974465e-18
			unit: 'J'
			uncertainty: 5.4e-26
		}
		'hartree-kelvin relationship': PhysicalConstant{
			name: 'hartree-kelvin relationship'
			value: 315775.13
			unit: 'K'
			uncertainty: 0.18
		}
		'hartree-kilogram relationship': PhysicalConstant{
			name: 'hartree-kilogram relationship'
			value: 4.850870129e-35
			unit: 'kg'
			uncertainty: 6e-43
		}
		'helion-electron mass ratio': PhysicalConstant{
			name: 'helion-electron mass ratio'
			value: 5495.88527922
			unit: ''
			uncertainty: 2.7e-07
		}
		'helion mass': PhysicalConstant{
			name: 'helion mass'
			value: 5.0064127e-27
			unit: 'kg'
			uncertainty: 6.2e-35
		}
		'helion mass energy equivalent': PhysicalConstant{
			name: 'helion mass energy equivalent'
			value: 4.499539341e-10
			unit: 'J'
			uncertainty: 5.5e-18
		}
		'helion mass energy equivalent in MeV': PhysicalConstant{
			name: 'helion mass energy equivalent in MeV'
			value: 2808.391586
			unit: 'MeV'
			uncertainty: 1.7e-05
		}
		'helion mass in u': PhysicalConstant{
			name: 'helion mass in u'
			value: 3.01493224673
			unit: 'u'
			uncertainty: 1.2e-10
		}
		'helion molar mass': PhysicalConstant{
			name: 'helion molar mass'
			value: 0.00301493224673
			unit: 'kg mol^-1'
			uncertainty: 1.2e-13
		}
		'helion-proton mass ratio': PhysicalConstant{
			name: 'helion-proton mass ratio'
			value: 2.99315267046
			unit: ''
			uncertainty: 2.9e-10
		}
		'hertz-atomic mass unit relationship': PhysicalConstant{
			name: 'hertz-atomic mass unit relationship'
			value: 4.4398216616e-24
			unit: 'u'
			uncertainty: 2e-33
		}
		'hertz-electron volt relationship': PhysicalConstant{
			name: 'hertz-electron volt relationship'
			value: 4.135667662e-15
			unit: 'eV'
			uncertainty: 2.5e-23
		}
		'hertz-hartree relationship': PhysicalConstant{
			name: 'hertz-hartree relationship'
			value: 1.5198298460088e-16
			unit: 'E_h'
			uncertainty: 9e-28
		}
		'hertz-inverse meter relationship': PhysicalConstant{
			name: 'hertz-inverse meter relationship'
			value: 3.3356409519815204e-09
			unit: 'm^-1'
			uncertainty: 0.0
		}
		'hertz-joule relationship': PhysicalConstant{
			name: 'hertz-joule relationship'
			value: 6.62607004e-34
			unit: 'J'
			uncertainty: 8.1e-42
		}
		'hertz-kelvin relationship': PhysicalConstant{
			name: 'hertz-kelvin relationship'
			value: 4.7992447e-11
			unit: 'K'
			uncertainty: 2.8e-17
		}
		'hertz-kilogram relationship': PhysicalConstant{
			name: 'hertz-kilogram relationship'
			value: 7.372497201e-51
			unit: 'kg'
			uncertainty: 9.1e-59
		}
		'inverse fine-structure constant': PhysicalConstant{
			name: 'inverse fine-structure constant'
			value: 137.035999139
			unit: ''
			uncertainty: 3.1e-08
		}
		'inverse meter-atomic mass unit relationship': PhysicalConstant{
			name: 'inverse meter-atomic mass unit relationship'
			value: 1.331025049e-15
			unit: 'u'
			uncertainty: 6.1e-25
		}
		'inverse meter-electron volt relationship': PhysicalConstant{
			name: 'inverse meter-electron volt relationship'
			value: 1.2398419739e-06
			unit: 'eV'
			uncertainty: 7.6e-15
		}
		'inverse meter-hartree relationship': PhysicalConstant{
			name: 'inverse meter-hartree relationship'
			value: 4.556335252767e-08
			unit: 'E_h'
			uncertainty: 2.7e-19
		}
		'inverse meter-hertz relationship': PhysicalConstant{
			name: 'inverse meter-hertz relationship'
			value: 299792458.0
			unit: 'Hz'
			uncertainty: 0.0
		}
		'inverse meter-joule relationship': PhysicalConstant{
			name: 'inverse meter-joule relationship'
			value: 1.986445824e-25
			unit: 'J'
			uncertainty: 2.4e-33
		}
		'inverse meter-kelvin relationship': PhysicalConstant{
			name: 'inverse meter-kelvin relationship'
			value: 0.0143877736
			unit: 'K'
			uncertainty: 8.3e-09
		}
		'inverse meter-kilogram relationship': PhysicalConstant{
			name: 'inverse meter-kilogram relationship'
			value: 2.210219057e-42
			unit: 'kg'
			uncertainty: 2.7e-50
		}
		'inverse of conductance quantum': PhysicalConstant{
			name: 'inverse of conductance quantum'
			value: 12906.4037278
			unit: 'ohm'
			uncertainty: 2.9e-06
		}
		'Josephson constant': PhysicalConstant{
			name: 'Josephson constant'
			value: 483597852500000.0
			unit: 'Hz V^-1'
			uncertainty: 3000000.0
		}
		'joule-atomic mass unit relationship': PhysicalConstant{
			name: 'joule-atomic mass unit relationship'
			value: 6700535363.0
			unit: 'u'
			uncertainty: 82.0
		}
		'joule-electron volt relationship': PhysicalConstant{
			name: 'joule-electron volt relationship'
			value: 6.241509126e+18
			unit: 'eV'
			uncertainty: 38000000000.0
		}
		'joule-hartree relationship': PhysicalConstant{
			name: 'joule-hartree relationship'
			value: 2.293712317e+17
			unit: 'E_h'
			uncertainty: 2800000000.0
		}
		'joule-hertz relationship': PhysicalConstant{
			name: 'joule-hertz relationship'
			value: 1.509190205e+33
			unit: 'Hz'
			uncertainty: 1.9e+25
		}
		'joule-inverse meter relationship': PhysicalConstant{
			name: 'joule-inverse meter relationship'
			value: 5.034116651e+24
			unit: 'm^-1'
			uncertainty: 6.2e+16
		}
		'joule-kelvin relationship': PhysicalConstant{
			name: 'joule-kelvin relationship'
			value: 7.2429731e+22
			unit: 'K'
			uncertainty: 4.2e+16
		}
		'joule-kilogram relationship': PhysicalConstant{
			name: 'joule-kilogram relationship'
			value: 1.1126500560536185e-17
			unit: 'kg'
			uncertainty: 0.0
		}
		'kelvin-atomic mass unit relationship': PhysicalConstant{
			name: 'kelvin-atomic mass unit relationship'
			value: 9.2510842e-14
			unit: 'u'
			uncertainty: 5.3e-20
		}
		'kelvin-electron volt relationship': PhysicalConstant{
			name: 'kelvin-electron volt relationship'
			value: 8.6173303e-05
			unit: 'eV'
			uncertainty: 5e-11
		}
		'kelvin-hartree relationship': PhysicalConstant{
			name: 'kelvin-hartree relationship'
			value: 3.1668105e-06
			unit: 'E_h'
			uncertainty: 1.8e-12
		}
		'kelvin-hertz relationship': PhysicalConstant{
			name: 'kelvin-hertz relationship'
			value: 20836612000.0
			unit: 'Hz'
			uncertainty: 12000.0
		}
		'kelvin-inverse meter relationship': PhysicalConstant{
			name: 'kelvin-inverse meter relationship'
			value: 69.503457
			unit: 'm^-1'
			uncertainty: 4e-05
		}
		'kelvin-joule relationship': PhysicalConstant{
			name: 'kelvin-joule relationship'
			value: 1.38064852e-23
			unit: 'J'
			uncertainty: 7.9e-30
		}
		'kelvin-kilogram relationship': PhysicalConstant{
			name: 'kelvin-kilogram relationship'
			value: 1.53617865e-40
			unit: 'kg'
			uncertainty: 8.8e-47
		}
		'kilogram-atomic mass unit relationship': PhysicalConstant{
			name: 'kilogram-atomic mass unit relationship'
			value: 6.022140857e+26
			unit: 'u'
			uncertainty: 7.4e+18
		}
		'kilogram-electron volt relationship': PhysicalConstant{
			name: 'kilogram-electron volt relationship'
			value: 5.60958865e+35
			unit: 'eV'
			uncertainty: 3.4e+27
		}
		'kilogram-hartree relationship': PhysicalConstant{
			name: 'kilogram-hartree relationship'
			value: 2.061485823e+34
			unit: 'E_h'
			uncertainty: 2.5e+26
		}
		'kilogram-hertz relationship': PhysicalConstant{
			name: 'kilogram-hertz relationship'
			value: 1.356392512e+50
			unit: 'Hz'
			uncertainty: 1.7e+42
		}
		'kilogram-inverse meter relationship': PhysicalConstant{
			name: 'kilogram-inverse meter relationship'
			value: 4.524438411e+41
			unit: 'm^-1'
			uncertainty: 5.6e+33
		}
		'kilogram-joule relationship': PhysicalConstant{
			name: 'kilogram-joule relationship'
			value: 8.987551787368176e+16
			unit: 'J'
			uncertainty: 0.0
		}
		'kilogram-kelvin relationship': PhysicalConstant{
			name: 'kilogram-kelvin relationship'
			value: 6.5096595e+39
			unit: 'K'
			uncertainty: 3.7e+33
		}
		'lattice parameter of silicon': PhysicalConstant{
			name: 'lattice parameter of silicon'
			value: 5.431020504e-10
			unit: 'm'
			uncertainty: 8.9e-18
		}
		'Loschmidt constant (273.15 K, 101.325 kPa)': PhysicalConstant{
			name: 'Loschmidt constant (273.15 K, 101.325 kPa)'
			value: 2.6867811e+25
			unit: 'm^-3'
			uncertainty: 1.5e+19
		}
		'mag. constant': PhysicalConstant{
			name: 'mag. constant'
			value: 1.2566370614359173e-06
			unit: 'N A^-2'
			uncertainty: 0.0
		}
		'mag. flux quantum': PhysicalConstant{
			name: 'mag. flux quantum'
			value: 2.067833831e-15
			unit: 'Wb'
			uncertainty: 1.3e-23
		}
		'molar gas constant': PhysicalConstant{
			name: 'molar gas constant'
			value: 8.3144598
			unit: 'J mol^-1 K^-1'
			uncertainty: 4.8e-06
		}
		'molar mass constant': PhysicalConstant{
			name: 'molar mass constant'
			value: 0.001
			unit: 'kg mol^-1'
			uncertainty: 0.0
		}
		'molar mass of carbon-12': PhysicalConstant{
			name: 'molar mass of carbon-12'
			value: 0.012
			unit: 'kg mol^-1'
			uncertainty: 0.0
		}
		'molar Planck constant': PhysicalConstant{
			name: 'molar Planck constant'
			value: 3.990312711e-10
			unit: 'J s mol^-1'
			uncertainty: 1.8e-19
		}
		'molar Planck constant times c': PhysicalConstant{
			name: 'molar Planck constant times c'
			value: 0.119626565582
			unit: 'J m mol^-1'
			uncertainty: 5.4e-11
		}
		'molar volume of ideal gas (273.15 K, 100 kPa)': PhysicalConstant{
			name: 'molar volume of ideal gas (273.15 K, 100 kPa)'
			value: 0.022710947
			unit: 'm^3 mol^-1'
			uncertainty: 1.3e-08
		}
		'molar volume of ideal gas (273.15 K, 101.325 kPa)': PhysicalConstant{
			name: 'molar volume of ideal gas (273.15 K, 101.325 kPa)'
			value: 0.022413962
			unit: 'm^3 mol^-1'
			uncertainty: 1.3e-08
		}
		'molar volume of silicon': PhysicalConstant{
			name: 'molar volume of silicon'
			value: 1.205883214e-05
			unit: 'm^3 mol^-1'
			uncertainty: 6.1e-13
		}
		'Mo x unit': PhysicalConstant{
			name: 'Mo x unit'
			value: 1.00209952e-13
			unit: 'm'
			uncertainty: 5.3e-20
		}
		'muon Compton wavelength': PhysicalConstant{
			name: 'muon Compton wavelength'
			value: 1.173444111e-14
			unit: 'm'
			uncertainty: 2.6e-22
		}
		'muon Compton wavelength over 2 pi': PhysicalConstant{
			name: 'muon Compton wavelength over 2 pi'
			value: 1.867594308e-15
			unit: 'm'
			uncertainty: 4.2e-23
		}
		'muon-electron mass ratio': PhysicalConstant{
			name: 'muon-electron mass ratio'
			value: 206.7682826
			unit: ''
			uncertainty: 4.6e-06
		}
		'muon g factor': PhysicalConstant{
			name: 'muon g factor'
			value: -2.0023318418
			unit: ''
			uncertainty: 1.3e-09
		}
		'muon mag. mom.': PhysicalConstant{
			name: 'muon mag. mom.'
			value: -4.49044826e-26
			unit: 'J T^-1'
			uncertainty: 1e-33
		}
		'muon mag. mom. anomaly': PhysicalConstant{
			name: 'muon mag. mom. anomaly'
			value: 0.00116592089
			unit: ''
			uncertainty: 6.3e-10
		}
		'muon mag. mom. to Bohr magneton ratio': PhysicalConstant{
			name: 'muon mag. mom. to Bohr magneton ratio'
			value: -0.00484197048
			unit: ''
			uncertainty: 1.1e-10
		}
		'muon mag. mom. to nuclear magneton ratio': PhysicalConstant{
			name: 'muon mag. mom. to nuclear magneton ratio'
			value: -8.89059705
			unit: ''
			uncertainty: 2e-07
		}
		'muon mass': PhysicalConstant{
			name: 'muon mass'
			value: 1.883531594e-28
			unit: 'kg'
			uncertainty: 4.8e-36
		}
		'muon mass energy equivalent': PhysicalConstant{
			name: 'muon mass energy equivalent'
			value: 1.692833774e-11
			unit: 'J'
			uncertainty: 4.3e-19
		}
		'muon mass energy equivalent in MeV': PhysicalConstant{
			name: 'muon mass energy equivalent in MeV'
			value: 105.6583745
			unit: 'MeV'
			uncertainty: 2.4e-06
		}
		'muon mass in u': PhysicalConstant{
			name: 'muon mass in u'
			value: 0.1134289257
			unit: 'u'
			uncertainty: 2.5e-09
		}
		'muon molar mass': PhysicalConstant{
			name: 'muon molar mass'
			value: 0.0001134289257
			unit: 'kg mol^-1'
			uncertainty: 2.5e-12
		}
		'muon-neutron mass ratio': PhysicalConstant{
			name: 'muon-neutron mass ratio'
			value: 0.1124545167
			unit: ''
			uncertainty: 2.5e-09
		}
		'muon-proton mag. mom. ratio': PhysicalConstant{
			name: 'muon-proton mag. mom. ratio'
			value: -3.183345142
			unit: ''
			uncertainty: 7.1e-08
		}
		'muon-proton mass ratio': PhysicalConstant{
			name: 'muon-proton mass ratio'
			value: 0.1126095262
			unit: ''
			uncertainty: 2.5e-09
		}
		'muon-tau mass ratio': PhysicalConstant{
			name: 'muon-tau mass ratio'
			value: 0.0594649
			unit: ''
			uncertainty: 5.4e-06
		}
		'natural unit of action': PhysicalConstant{
			name: 'natural unit of action'
			value: 1.0545718e-34
			unit: 'J s'
			uncertainty: 1.3e-42
		}
		'natural unit of action in eV s': PhysicalConstant{
			name: 'natural unit of action in eV s'
			value: 6.582119514e-16
			unit: 'eV s'
			uncertainty: 4e-24
		}
		'natural unit of energy': PhysicalConstant{
			name: 'natural unit of energy'
			value: 8.18710565e-14
			unit: 'J'
			uncertainty: 1e-21
		}
		'natural unit of energy in MeV': PhysicalConstant{
			name: 'natural unit of energy in MeV'
			value: 0.5109989461
			unit: 'MeV'
			uncertainty: 3.1e-09
		}
		'natural unit of length': PhysicalConstant{
			name: 'natural unit of length'
			value: 3.8615926764e-13
			unit: 'm'
			uncertainty: 1.8e-22
		}
		'natural unit of mass': PhysicalConstant{
			name: 'natural unit of mass'
			value: 9.10938356e-31
			unit: 'kg'
			uncertainty: 1.1e-38
		}
		'natural unit of momentum': PhysicalConstant{
			name: 'natural unit of momentum'
			value: 2.730924488e-22
			unit: 'kg m s^-1'
			uncertainty: 3.4e-30
		}
		'natural unit of momentum in MeV/c': PhysicalConstant{
			name: 'natural unit of momentum in MeV/c'
			value: 0.5109989461
			unit: 'MeV/c'
			uncertainty: 3.1e-09
		}
		'natural unit of time': PhysicalConstant{
			name: 'natural unit of time'
			value: 1.28808866712e-21
			unit: 's'
			uncertainty: 5.8e-31
		}
		'natural unit of velocity': PhysicalConstant{
			name: 'natural unit of velocity'
			value: 299792458.0
			unit: 'm s^-1'
			uncertainty: 0.0
		}
		'neutron Compton wavelength': PhysicalConstant{
			name: 'neutron Compton wavelength'
			value: 1.31959090481e-15
			unit: 'm'
			uncertainty: 8.8e-25
		}
		'neutron Compton wavelength over 2 pi': PhysicalConstant{
			name: 'neutron Compton wavelength over 2 pi'
			value: 2.1001941536e-16
			unit: 'm'
			uncertainty: 1.4e-25
		}
		'neutron-electron mag. mom. ratio': PhysicalConstant{
			name: 'neutron-electron mag. mom. ratio'
			value: 0.00104066882
			unit: ''
			uncertainty: 2.5e-10
		}
		'neutron-electron mass ratio': PhysicalConstant{
			name: 'neutron-electron mass ratio'
			value: 1838.68366158
			unit: ''
			uncertainty: 9e-07
		}
		'neutron g factor': PhysicalConstant{
			name: 'neutron g factor'
			value: -3.82608545
			unit: ''
			uncertainty: 9e-07
		}
		'neutron gyromag. ratio': PhysicalConstant{
			name: 'neutron gyromag. ratio'
			value: 183247172.0
			unit: 's^-1 T^-1'
			uncertainty: 43.0
		}
		'neutron gyromag. ratio over 2 pi': PhysicalConstant{
			name: 'neutron gyromag. ratio over 2 pi'
			value: 29.1646933
			unit: 'MHz T^-1'
			uncertainty: 6.9e-06
		}
		'neutron mag. mom.': PhysicalConstant{
			name: 'neutron mag. mom.'
			value: -9.662365e-27
			unit: 'J T^-1'
			uncertainty: 2.3e-33
		}
		'neutron mag. mom. to Bohr magneton ratio': PhysicalConstant{
			name: 'neutron mag. mom. to Bohr magneton ratio'
			value: -0.00104187563
			unit: ''
			uncertainty: 2.5e-10
		}
		'neutron mag. mom. to nuclear magneton ratio': PhysicalConstant{
			name: 'neutron mag. mom. to nuclear magneton ratio'
			value: -1.91304273
			unit: ''
			uncertainty: 4.5e-07
		}
		'neutron mass': PhysicalConstant{
			name: 'neutron mass'
			value: 1.674927471e-27
			unit: 'kg'
			uncertainty: 2.1e-35
		}
		'neutron mass energy equivalent': PhysicalConstant{
			name: 'neutron mass energy equivalent'
			value: 1.505349739e-10
			unit: 'J'
			uncertainty: 1.9e-18
		}
		'neutron mass energy equivalent in MeV': PhysicalConstant{
			name: 'neutron mass energy equivalent in MeV'
			value: 939.5654133
			unit: 'MeV'
			uncertainty: 5.8e-06
		}
		'neutron mass in u': PhysicalConstant{
			name: 'neutron mass in u'
			value: 1.00866491588
			unit: 'u'
			uncertainty: 4.9e-10
		}
		'neutron molar mass': PhysicalConstant{
			name: 'neutron molar mass'
			value: 0.00100866491588
			unit: 'kg mol^-1'
			uncertainty: 4.9e-13
		}
		'neutron-muon mass ratio': PhysicalConstant{
			name: 'neutron-muon mass ratio'
			value: 8.89248408
			unit: ''
			uncertainty: 2e-07
		}
		'neutron-proton mag. mom. ratio': PhysicalConstant{
			name: 'neutron-proton mag. mom. ratio'
			value: -0.68497934
			unit: ''
			uncertainty: 1.6e-07
		}
		'neutron-proton mass ratio': PhysicalConstant{
			name: 'neutron-proton mass ratio'
			value: 1.00137841898
			unit: ''
			uncertainty: 5.1e-10
		}
		'neutron-tau mass ratio': PhysicalConstant{
			name: 'neutron-tau mass ratio'
			value: 0.52879
			unit: ''
			uncertainty: 4.8e-05
		}
		'neutron to shielded proton mag. mom. ratio': PhysicalConstant{
			name: 'neutron to shielded proton mag. mom. ratio'
			value: -0.68499694
			unit: ''
			uncertainty: 1.6e-07
		}
		'Newtonian constant of gravitation': PhysicalConstant{
			name: 'Newtonian constant of gravitation'
			value: 6.67408e-11
			unit: 'm^3 kg^-1 s^-2'
			uncertainty: 3.1e-15
		}
		'Newtonian constant of gravitation over h-bar c': PhysicalConstant{
			name: 'Newtonian constant of gravitation over h-bar c'
			value: 6.70861e-39
			unit: '(GeV/c^2)^-2'
			uncertainty: 3.1e-43
		}
		'nuclear magneton': PhysicalConstant{
			name: 'nuclear magneton'
			value: 5.050783699e-27
			unit: 'J T^-1'
			uncertainty: 3.1e-35
		}
		'nuclear magneton in eV/T': PhysicalConstant{
			name: 'nuclear magneton in eV/T'
			value: 3.152451255e-08
			unit: 'eV T^-1'
			uncertainty: 1.5e-17
		}
		'nuclear magneton in inverse meters per tesla': PhysicalConstant{
			name: 'nuclear magneton in inverse meters per tesla'
			value: 0.02542623432
			unit: 'm^-1 T^-1'
			uncertainty: 1.6e-10
		}
		'nuclear magneton in K/T': PhysicalConstant{
			name: 'nuclear magneton in K/T'
			value: 0.0003658269
			unit: 'K T^-1'
			uncertainty: 2.1e-10
		}
		'nuclear magneton in MHz/T': PhysicalConstant{
			name: 'nuclear magneton in MHz/T'
			value: 7.622593285
			unit: 'MHz T^-1'
			uncertainty: 4.7e-08
		}
		'Planck constant': PhysicalConstant{
			name: 'Planck constant'
			value: 6.62607004e-34
			unit: 'J s'
			uncertainty: 8.1e-42
		}
		'Planck constant in eV s': PhysicalConstant{
			name: 'Planck constant in eV s'
			value: 4.135667662e-15
			unit: 'eV s'
			uncertainty: 2.5e-23
		}
		'Planck constant over 2 pi': PhysicalConstant{
			name: 'Planck constant over 2 pi'
			value: 1.0545718e-34
			unit: 'J s'
			uncertainty: 1.3e-42
		}
		'Planck constant over 2 pi in eV s': PhysicalConstant{
			name: 'Planck constant over 2 pi in eV s'
			value: 6.582119514e-16
			unit: 'eV s'
			uncertainty: 4e-24
		}
		'Planck constant over 2 pi times c in MeV fm': PhysicalConstant{
			name: 'Planck constant over 2 pi times c in MeV fm'
			value: 197.3269788
			unit: 'MeV fm'
			uncertainty: 1.2e-06
		}
		'Planck length': PhysicalConstant{
			name: 'Planck length'
			value: 1.616229e-35
			unit: 'm'
			uncertainty: 3.8e-40
		}
		'Planck mass': PhysicalConstant{
			name: 'Planck mass'
			value: 2.17647e-08
			unit: 'kg'
			uncertainty: 5.1e-13
		}
		'Planck mass energy equivalent in GeV': PhysicalConstant{
			name: 'Planck mass energy equivalent in GeV'
			value: 1.22091e+19
			unit: 'GeV'
			uncertainty: 290000000000000.0
		}
		'Planck temperature': PhysicalConstant{
			name: 'Planck temperature'
			value: 1.416808e+32
			unit: 'K'
			uncertainty: 3.3e+27
		}
		'Planck time': PhysicalConstant{
			name: 'Planck time'
			value: 5.39116e-44
			unit: 's'
			uncertainty: 1.3e-48
		}
		'proton charge to mass quotient': PhysicalConstant{
			name: 'proton charge to mass quotient'
			value: 95788332.26
			unit: 'C kg^-1'
			uncertainty: 0.59
		}
		'proton Compton wavelength': PhysicalConstant{
			name: 'proton Compton wavelength'
			value: 1.32140985396e-15
			unit: 'm'
			uncertainty: 6.1e-25
		}
		'proton Compton wavelength over 2 pi': PhysicalConstant{
			name: 'proton Compton wavelength over 2 pi'
			value: 2.10308910109e-16
			unit: 'm'
			uncertainty: 9.7e-26
		}
		'proton-electron mass ratio': PhysicalConstant{
			name: 'proton-electron mass ratio'
			value: 1836.15267389
			unit: ''
			uncertainty: 1.7e-07
		}
		'proton g factor': PhysicalConstant{
			name: 'proton g factor'
			value: 5.585694702
			unit: ''
			uncertainty: 1.7e-08
		}
		'proton gyromag. ratio': PhysicalConstant{
			name: 'proton gyromag. ratio'
			value: 267522190.0
			unit: 's^-1 T^-1'
			uncertainty: 1.8
		}
		'proton gyromag. ratio over 2 pi': PhysicalConstant{
			name: 'proton gyromag. ratio over 2 pi'
			value: 42.57747892
			unit: 'MHz T^-1'
			uncertainty: 2.9e-07
		}
		'proton mag. mom.': PhysicalConstant{
			name: 'proton mag. mom.'
			value: 1.4106067873e-26
			unit: 'J T^-1'
			uncertainty: 9.7e-35
		}
		'proton mag. mom. to Bohr magneton ratio': PhysicalConstant{
			name: 'proton mag. mom. to Bohr magneton ratio'
			value: 0.0015210322053
			unit: ''
			uncertainty: 4.6e-12
		}
		'proton mag. mom. to nuclear magneton ratio': PhysicalConstant{
			name: 'proton mag. mom. to nuclear magneton ratio'
			value: 2.7928473508
			unit: ''
			uncertainty: 8.5e-09
		}
		'proton mag. shielding correction': PhysicalConstant{
			name: 'proton mag. shielding correction'
			value: 2.5691e-05
			unit: ''
			uncertainty: 1.1e-08
		}
		'proton mass': PhysicalConstant{
			name: 'proton mass'
			value: 1.672621898e-27
			unit: 'kg'
			uncertainty: 2.1e-35
		}
		'proton mass energy equivalent': PhysicalConstant{
			name: 'proton mass energy equivalent'
			value: 1.503277593e-10
			unit: 'J'
			uncertainty: 1.8e-18
		}
		'proton mass energy equivalent in MeV': PhysicalConstant{
			name: 'proton mass energy equivalent in MeV'
			value: 938.2720813
			unit: 'MeV'
			uncertainty: 5.8e-06
		}
		'proton mass in u': PhysicalConstant{
			name: 'proton mass in u'
			value: 1.007276466879
			unit: 'u'
			uncertainty: 9.1e-11
		}
		'proton molar mass': PhysicalConstant{
			name: 'proton molar mass'
			value: 0.001007276466879
			unit: 'kg mol^-1'
			uncertainty: 9.1e-14
		}
		'proton-muon mass ratio': PhysicalConstant{
			name: 'proton-muon mass ratio'
			value: 8.88024338
			unit: ''
			uncertainty: 2e-07
		}
		'proton-neutron mag. mom. ratio': PhysicalConstant{
			name: 'proton-neutron mag. mom. ratio'
			value: -1.45989805
			unit: ''
			uncertainty: 3.4e-07
		}
		'proton-neutron mass ratio': PhysicalConstant{
			name: 'proton-neutron mass ratio'
			value: 0.99862347844
			unit: ''
			uncertainty: 5.1e-10
		}
		'proton rms charge radius': PhysicalConstant{
			name: 'proton rms charge radius'
			value: 8.751e-16
			unit: 'm'
			uncertainty: 6.1e-18
		}
		'proton-tau mass ratio': PhysicalConstant{
			name: 'proton-tau mass ratio'
			value: 0.528063
			unit: ''
			uncertainty: 4.8e-05
		}
		'quantum of circulation': PhysicalConstant{
			name: 'quantum of circulation'
			value: 0.00036369475486
			unit: 'm^2 s^-1'
			uncertainty: 1.7e-13
		}
		'quantum of circulation times 2': PhysicalConstant{
			name: 'quantum of circulation times 2'
			value: 0.00072738950972
			unit: 'm^2 s^-1'
			uncertainty: 3.3e-13
		}
		'Rydberg constant': PhysicalConstant{
			name: 'Rydberg constant'
			value: 10973731.568508
			unit: 'm^-1'
			uncertainty: 6.5e-05
		}
		'Rydberg constant times c in Hz': PhysicalConstant{
			name: 'Rydberg constant times c in Hz'
			value: 3289841960355000.0
			unit: 'Hz'
			uncertainty: 19000.0
		}
		'Rydberg constant times hc in eV': PhysicalConstant{
			name: 'Rydberg constant times hc in eV'
			value: 13.605693009
			unit: 'eV'
			uncertainty: 8.4e-08
		}
		'Rydberg constant times hc in J': PhysicalConstant{
			name: 'Rydberg constant times hc in J'
			value: 2.179872325e-18
			unit: 'J'
			uncertainty: 2.7e-26
		}
		'Sackur-Tetrode constant (1 K, 100 kPa)': PhysicalConstant{
			name: 'Sackur-Tetrode constant (1 K, 100 kPa)'
			value: -1.1517084
			unit: ''
			uncertainty: 1.4e-06
		}
		'Sackur-Tetrode constant (1 K, 101.325 kPa)': PhysicalConstant{
			name: 'Sackur-Tetrode constant (1 K, 101.325 kPa)'
			value: -1.1648714
			unit: ''
			uncertainty: 1.4e-06
		}
		'second radiation constant': PhysicalConstant{
			name: 'second radiation constant'
			value: 0.0143877736
			unit: 'm K'
			uncertainty: 8.3e-09
		}
		'shielded helion gyromag. ratio': PhysicalConstant{
			name: 'shielded helion gyromag. ratio'
			value: 203789458.5
			unit: 's^-1 T^-1'
			uncertainty: 2.7
		}
		'shielded helion gyromag. ratio over 2 pi': PhysicalConstant{
			name: 'shielded helion gyromag. ratio over 2 pi'
			value: 32.43409966
			unit: 'MHz T^-1'
			uncertainty: 4.3e-07
		}
		'shielded helion mag. mom.': PhysicalConstant{
			name: 'shielded helion mag. mom.'
			value: -1.07455308e-26
			unit: 'J T^-1'
			uncertainty: 1.4e-34
		}
		'shielded helion mag. mom. to Bohr magneton ratio': PhysicalConstant{
			name: 'shielded helion mag. mom. to Bohr magneton ratio'
			value: -0.001158671471
			unit: ''
			uncertainty: 1.4e-11
		}
		'shielded helion mag. mom. to nuclear magneton ratio': PhysicalConstant{
			name: 'shielded helion mag. mom. to nuclear magneton ratio'
			value: -2.12749772
			unit: ''
			uncertainty: 2.5e-08
		}
		'shielded helion to proton mag. mom. ratio': PhysicalConstant{
			name: 'shielded helion to proton mag. mom. ratio'
			value: -0.7617665603
			unit: ''
			uncertainty: 9.2e-09
		}
		'shielded helion to shielded proton mag. mom. ratio': PhysicalConstant{
			name: 'shielded helion to shielded proton mag. mom. ratio'
			value: -0.7617861313
			unit: ''
			uncertainty: 3.3e-09
		}
		'shielded proton gyromag. ratio': PhysicalConstant{
			name: 'shielded proton gyromag. ratio'
			value: 267515317.1
			unit: 's^-1 T^-1'
			uncertainty: 3.3
		}
		'shielded proton gyromag. ratio over 2 pi': PhysicalConstant{
			name: 'shielded proton gyromag. ratio over 2 pi'
			value: 42.57638507
			unit: 'MHz T^-1'
			uncertainty: 5.3e-07
		}
		'shielded proton mag. mom.': PhysicalConstant{
			name: 'shielded proton mag. mom.'
			value: 1.410570547e-26
			unit: 'J T^-1'
			uncertainty: 1.8e-34
		}
		'shielded proton mag. mom. to Bohr magneton ratio': PhysicalConstant{
			name: 'shielded proton mag. mom. to Bohr magneton ratio'
			value: 0.001520993128
			unit: ''
			uncertainty: 1.7e-11
		}
		'shielded proton mag. mom. to nuclear magneton ratio': PhysicalConstant{
			name: 'shielded proton mag. mom. to nuclear magneton ratio'
			value: 2.7927756
			unit: ''
			uncertainty: 3e-08
		}
		'speed of light in vacuum': PhysicalConstant{
			name: 'speed of light in vacuum'
			value: 299792458.0
			unit: 'm s^-1'
			uncertainty: 0.0
		}
		'standard acceleration of gravity': PhysicalConstant{
			name: 'standard acceleration of gravity'
			value: 9.80665
			unit: 'm s^-2'
			uncertainty: 0.0
		}
		'standard atmosphere': PhysicalConstant{
			name: 'standard atmosphere'
			value: 101325.0
			unit: 'Pa'
			uncertainty: 0.0
		}
		'Stefan-Boltzmann constant': PhysicalConstant{
			name: 'Stefan-Boltzmann constant'
			value: 5.670367e-08
			unit: 'W m^-2 K^-4'
			uncertainty: 1.3e-13
		}
		'tau Compton wavelength': PhysicalConstant{
			name: 'tau Compton wavelength'
			value: 6.97787e-16
			unit: 'm'
			uncertainty: 6.3e-20
		}
		'tau Compton wavelength over 2 pi': PhysicalConstant{
			name: 'tau Compton wavelength over 2 pi'
			value: 1.11056e-16
			unit: 'm'
			uncertainty: 1e-20
		}
		'tau-electron mass ratio': PhysicalConstant{
			name: 'tau-electron mass ratio'
			value: 3477.15
			unit: ''
			uncertainty: 0.31
		}
		'tau mass': PhysicalConstant{
			name: 'tau mass'
			value: 3.16747e-27
			unit: 'kg'
			uncertainty: 2.9e-31
		}
		'tau mass energy equivalent': PhysicalConstant{
			name: 'tau mass energy equivalent'
			value: 2.84678e-10
			unit: 'J'
			uncertainty: 2.6e-14
		}
		'tau mass energy equivalent in MeV': PhysicalConstant{
			name: 'tau mass energy equivalent in MeV'
			value: 1776.82
			unit: 'MeV'
			uncertainty: 0.16
		}
		'tau mass in u': PhysicalConstant{
			name: 'tau mass in u'
			value: 1.90749
			unit: 'u'
			uncertainty: 0.00017
		}
		'tau molar mass': PhysicalConstant{
			name: 'tau molar mass'
			value: 0.00190749
			unit: 'kg mol^-1'
			uncertainty: 1.7e-07
		}
		'tau-muon mass ratio': PhysicalConstant{
			name: 'tau-muon mass ratio'
			value: 16.8167
			unit: ''
			uncertainty: 0.0015
		}
		'tau-neutron mass ratio': PhysicalConstant{
			name: 'tau-neutron mass ratio'
			value: 1.89111
			unit: ''
			uncertainty: 0.00017
		}
		'tau-proton mass ratio': PhysicalConstant{
			name: 'tau-proton mass ratio'
			value: 1.89372
			unit: ''
			uncertainty: 0.00017
		}
		'Thomson cross section': PhysicalConstant{
			name: 'Thomson cross section'
			value: 6.6524587158e-29
			unit: 'm^2'
			uncertainty: 9.1e-38
		}
		'triton-electron mag. mom. ratio': PhysicalConstant{
			name: 'triton-electron mag. mom. ratio'
			value: -0.001620514423
			unit: ''
			uncertainty: 2.1e-11
		}
		'triton-electron mass ratio': PhysicalConstant{
			name: 'triton-electron mass ratio'
			value: 5496.92153588
			unit: ''
			uncertainty: 2.6e-07
		}
		'triton g factor': PhysicalConstant{
			name: 'triton g factor'
			value: 5.95792492
			unit: ''
			uncertainty: 2.8e-08
		}
		'triton mag. mom.': PhysicalConstant{
			name: 'triton mag. mom.'
			value: 1.504609503e-26
			unit: 'J T^-1'
			uncertainty: 1.2e-34
		}
		'triton mag. mom. to Bohr magneton ratio': PhysicalConstant{
			name: 'triton mag. mom. to Bohr magneton ratio'
			value: 0.0016223936616
			unit: ''
			uncertainty: 7.6e-12
		}
		'triton mag. mom. to nuclear magneton ratio': PhysicalConstant{
			name: 'triton mag. mom. to nuclear magneton ratio'
			value: 2.97896246
			unit: ''
			uncertainty: 1.4e-08
		}
		'triton mass': PhysicalConstant{
			name: 'triton mass'
			value: 5.007356665e-27
			unit: 'kg'
			uncertainty: 6.2e-35
		}
		'triton mass energy equivalent': PhysicalConstant{
			name: 'triton mass energy equivalent'
			value: 4.500387735e-10
			unit: 'J'
			uncertainty: 5.5e-18
		}
		'triton mass energy equivalent in MeV': PhysicalConstant{
			name: 'triton mass energy equivalent in MeV'
			value: 2808.921112
			unit: 'MeV'
			uncertainty: 1.7e-05
		}
		'triton mass in u': PhysicalConstant{
			name: 'triton mass in u'
			value: 3.01550071632
			unit: 'u'
			uncertainty: 1.1e-10
		}
		'triton molar mass': PhysicalConstant{
			name: 'triton molar mass'
			value: 0.00301550071632
			unit: 'kg mol^-1'
			uncertainty: 1.1e-13
		}
		'triton-neutron mag. mom. ratio': PhysicalConstant{
			name: 'triton-neutron mag. mom. ratio'
			value: -1.55718553
			unit: ''
			uncertainty: 3.7e-07
		}
		'triton-proton mag. mom. ratio': PhysicalConstant{
			name: 'triton-proton mag. mom. ratio'
			value: 1.066639908
			unit: ''
			uncertainty: 1e-08
		}
		'triton-proton mass ratio': PhysicalConstant{
			name: 'triton-proton mass ratio'
			value: 2.99371703348
			unit: ''
			uncertainty: 2.2e-10
		}
		'unified atomic mass unit': PhysicalConstant{
			name: 'unified atomic mass unit'
			value: 1.66053904e-27
			unit: 'kg'
			uncertainty: 2e-35
		}
		'von Klitzing constant': PhysicalConstant{
			name: 'von Klitzing constant'
			value: 25812.8074555
			unit: 'ohm'
			uncertainty: 5.9e-06
		}
		'weak mixing angle': PhysicalConstant{
			name: 'weak mixing angle'
			value: 0.2223
			unit: ''
			uncertainty: 0.0021
		}
		'Wien frequency displacement law constant': PhysicalConstant{
			name: 'Wien frequency displacement law constant'
			value: 58789238000.0
			unit: 'Hz K^-1'
			uncertainty: 34000.0
		}
		'Wien wavelength displacement law constant': PhysicalConstant{
			name: 'Wien wavelength displacement law constant'
			value: 0.0028977729
			unit: 'm K'
			uncertainty: 1.7e-09
		}
		'atomic unit of mom.um': PhysicalConstant{
			name: 'atomic unit of mom.um'
			value: 1.992851882e-24
			unit: 'kg m s^-1'
			uncertainty: 2.4e-32
		}
		'electron-helion mass ratio': PhysicalConstant{
			name: 'electron-helion mass ratio'
			value: 0.0001819543074854
			unit: ''
			uncertainty: 8.8e-15
		}
		'electron-triton mass ratio': PhysicalConstant{
			name: 'electron-triton mass ratio'
			value: 0.0001819200062203
			unit: ''
			uncertainty: 8.4e-15
		}
		'helion g factor': PhysicalConstant{
			name: 'helion g factor'
			value: -4.255250616
			unit: ''
			uncertainty: 5e-08
		}
		'helion mag. mom.': PhysicalConstant{
			name: 'helion mag. mom.'
			value: -1.074617522e-26
			unit: 'J T^-1'
			uncertainty: 1.4e-34
		}
		'helion mag. mom. to Bohr magneton ratio': PhysicalConstant{
			name: 'helion mag. mom. to Bohr magneton ratio'
			value: -0.001158740958
			unit: ''
			uncertainty: 1.4e-11
		}
		'helion mag. mom. to nuclear magneton ratio': PhysicalConstant{
			name: 'helion mag. mom. to nuclear magneton ratio'
			value: -2.127625308
			unit: ''
			uncertainty: 2.5e-08
		}
		'Loschmidt constant (273.15 K, 100 kPa)': PhysicalConstant{
			name: 'Loschmidt constant (273.15 K, 100 kPa)'
			value: 2.6516467e+25
			unit: 'm^-3'
			uncertainty: 1.5e+19
		}
		'natural unit of mom.um': PhysicalConstant{
			name: 'natural unit of mom.um'
			value: 2.730924488e-22
			unit: 'kg m s^-1'
			uncertainty: 3.4e-30
		}
		'natural unit of mom.um in MeV/c': PhysicalConstant{
			name: 'natural unit of mom.um in MeV/c'
			value: 0.5109989461
			unit: 'MeV/c'
			uncertainty: 3.1e-09
		}
		'neutron-proton mass difference': PhysicalConstant{
			name: 'neutron-proton mass difference'
			value: 2.30557377e-30
			unit: ''
			uncertainty: 8.5e-37
		}
		'neutron-proton mass difference energy equivalent': PhysicalConstant{
			name: 'neutron-proton mass difference energy equivalent'
			value: 2.07214637e-13
			unit: ''
			uncertainty: 7.6e-20
		}
		'neutron-proton mass difference energy equivalent in MeV': PhysicalConstant{
			name: 'neutron-proton mass difference energy equivalent in MeV'
			value: 1.29333205
			unit: ''
			uncertainty: 4.8e-07
		}
		'neutron-proton mass difference in u': PhysicalConstant{
			name: 'neutron-proton mass difference in u'
			value: 0.001388449
			unit: ''
			uncertainty: 5.1e-10
		}
		'standard-state pressure': PhysicalConstant{
			name: 'standard-state pressure'
			value: 100000.0
			unit: 'Pa'
			uncertainty: 0.0
		}
	}
)
